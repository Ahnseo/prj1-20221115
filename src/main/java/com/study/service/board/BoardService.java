package com.study.service.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.study.domain.board.BoardDto;
import com.study.domain.board.PageInfo;
import com.study.domain.board.ViewDto;
import com.study.mapper.board.BoardMapper;
import com.study.mapper.board.ReplyMapper;
import com.study.mapper.board.ViewMapper;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Service
@Transactional
public class BoardService {
	
	@Autowired
	private BoardMapper boardMapper;
	
	@Autowired
	private ReplyMapper replyMapper;
	
	@Autowired
	private ViewMapper viewMapper;
	
	@Autowired
	private S3Client s3Client;
	
	@Value("${aws.s3.bucket}") //import org.springframework.beans.factory.annotation.Value;
	private String bucketName;
	
	
	/**  */
	@Transactional
	public int register(BoardDto board, MultipartFile[] files) {
		
		//(버그 수정 2022.11.09) 제목을 꼭 입력해야하길 바람. => register.jsp => JavaScript 처리
		
		//db 게시물 정보 저장, xml : <insert id="insertBoard" keyProperty="id" useGeneratedKeys="true"> 	 
		int cnt = boardMapper.insertBoard(board);	 
		 

		 //파일 업로드 하기
		 for(MultipartFile file : files) {
			 
			 if(file != null && file.getSize() > 0) { 
				 //db에 파일 정보 저장 : 파일명, 게시물id => db테이블 만들기
				 boardMapper.insertFile(board.getId(), file.getOriginalFilename());
				 
				// AWS s3에 저장 (하드디스크에 저장하지 않기)
				uploadFile(board.getId(), file); 
					 
				/*	 
				 //실제 파일이 어디 저장되는지?  하드디스크에 저장해보기
				 //board id(PrimaryKey이용한) 여러 새폴더 자동 생성하기
				 File folder = new File("C:\\Users\\user\\Desktop\\study\\upload\\prj1\\board\\" + board.getId());
				 folder.mkdirs();
				 
				 File dest = new File(folder, file.getOriginalFilename());
				 
				 try { 
					 file.transferTo(dest);
				} catch (Exception e) {
					//@Transactional 은 RuntimeException에서만 롤백됨
					e.printStackTrace();
					throw new RuntimeException(e);
				}
				*/	 
				 
			} 
		}
		 
		 
		 return cnt;
	}

	

	/**  */                              // 파라미터 순서 잘지켜라
	public List<BoardDto> listBoard(int page, PageInfo pageInfo, String keyword, String type) {
		int records = 10;
		int offset = (page - 1) * records; 
		
		int countAll = boardMapper.countAll("%"+keyword+"%", type); //SELECT COUNT(*) FROM Board
		//System.out.println(countAll);
		
		int lastPageNumber = (countAll - 1) / records  + 1; 
		
		int leftPageNumber = (page - 1) / 10 * 10 + 1;	
		
		int rightPageNumber = leftPageNumber + 9;
			//System.out.println(lastPageNumber);
			//System.out.println(rightPageNumber);
			rightPageNumber = Math.min(lastPageNumber, rightPageNumber);
			
				
		int currentPageNumber = page;
		pageInfo.setCurrentPageNumber(currentPageNumber);
		pageInfo.setLastPageNumber(lastPageNumber);
		
		pageInfo.setLeftPageNumber(leftPageNumber);
		pageInfo.setRightPageNumber(rightPageNumber);
		
		//이전 버튼 유무
		boolean hasPrevButton = page > 10;
		int jumpPrevPageNumber = (page - 1) /10 * 10 - 9;
		pageInfo.setHasPrevButton(hasPrevButton);
		pageInfo.setJumpPrevPageNumber(jumpPrevPageNumber);
		
		//다음 버튼 유무
		boolean hasNextButton = page<= ( (lastPageNumber - 1) / 10 * 10);
		int jumpNextPageNumber = (page - 1) /10 * 10 + 11;
		pageInfo.setHasNextButton(hasNextButton);
		pageInfo.setJumpNextPageNumber(jumpNextPageNumber);
		
		
		return boardMapper.list(offset, records, "%"+keyword+"%", type);
	}
	
	/** BoardId 가져오기 */
	public BoardDto getBoardById(int id) {
		
		return boardMapper.selectBoardById(id);
	}
	
	
	
	/** 수정된 정보를 최신화 시키기. forward => modify.jsp */
	public void modify(int id, Model model) {
		BoardDto board = boardMapper.selectBoardById(id);
		model.addAttribute("board", board);	
	}

	/** 수정 */
	public int update(BoardDto board, MultipartFile[] addFiles, List<String> removeFiles) {
		int cnt = boardMapper.update(board);
		
		// 1.Files table에서 같은 이름의 파일이 있는가? -> 지우기 (덮어씌우려공)
		//checkbox remove : removefile checkBox 에서 fileName과 boardId 가 일치하면 삭제.
		if(removeFiles != null ) {
			for(String fileName : removeFiles) {
				// db 지우기
				int boardId = board.getId();
				boardMapper.deleteFileByBoardIdAndFileName(boardId, fileName);
				//실제 저장소안의 file 지우기
				deleteFile(boardId, fileName);
			}
		}

		// 2. aws s3 버켓에 업로드하기
		for(MultipartFile file : addFiles) {
			if (file != null && file.getSize() > 0 ) {				
				int boardId = board.getId();
				
				//db에 수정하기.
				boardMapper.deleteFileByBoardIdAndFileName(boardId, file.getOriginalFilename());
				boardMapper.insertFile(boardId, file.getOriginalFilename());	
				
				//aws s3 버켓에 업로드하기
				
				uploadFile(board.getId(), file); 
				
			}
		}
		
		return cnt;
	}
	
	
	/** 삭제  */
	//두가지 일이 하나의 업무이므로 , 트렌젝셔날
	//@Transactional
	public int remove(int id) {
		
		//** aws s3 안에 파일 지우기
		BoardDto board = boardMapper.selectBoardById(id);
		List <String> fileNames = board.getFileName();
		
		//System.out.println(board.getId());
		//System.out.println(id);
		
		if (fileNames != null) {
			for(String fileName : fileNames) {
				System.out.println(fileName);
				
				deleteFile(id, fileName);
				
			}
		}
		//String forderKey = "/prj1/board/" + board.getId() + "/";
		//DeleteObjectRequest dorForder = DeleteObjectRequest.builder().bucket(bucketName).key(forderKey).build();
		//s3Client.deleteObject(dorForder);
		
		//1.(DB) 게시물의 '댓글'들을 먼저 지우기, 실제 현업에서는 지우지않음, 전부 자산이기 때문에, 지웠다는 표시만함.
		replyMapper.deleteByBoardId(id);
		
		//2.(DB) 업로드 파일 또한 먼저지워줘야함.
		boardMapper.deleteFilesByBoardId(id);
		
		//3.(DB) 게시물 최종 지우기
		return boardMapper.remove(id);	
	}

	//################# 메소드 만든 #################################################################################
	
	private void deleteFile(int id, String fileName) {
		String key = "prj1/board/" + id + "/" + fileName;
		DeleteObjectRequest deleteObjectRequestFile = DeleteObjectRequest.builder()
																		  .bucket(bucketName)
																		  .key(key)
																		  .build();
		
		s3Client.deleteObject(deleteObjectRequestFile);
	}
	
	private void uploadFile(int id, MultipartFile file) {
		try {
			// 키 생성
			String key = "prj1/board/" + id + "/" + file.getOriginalFilename();
			
			//putObjectRequest
			PutObjectRequest putObjectRequest = PutObjectRequest.builder()
																.bucket(bucketName)
																.key(key)
																.acl(ObjectCannedACL.PUBLIC_READ) // 권한 설정
																.build();
			
			//requestBody
			RequestBody	requestBody	= RequestBody.fromInputStream(file.getInputStream(), file.getSize());	
			
			//object(파일) 업로드 하기
			s3Client.putObject(putObjectRequest , requestBody);
			
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}



	public Map<String, Object> updateLike(String boardId, String memberId) {
		// boardId 와 username 으로 BoardLike테이블을 검색해서  있으면? delete , 없으면? insert
		int cnt = boardMapper.getLikeByBoardIdAndMemerId(boardId, memberId);
		
		Map<String, Object> map = new HashMap<>();
		if(cnt == 1) { //존재하면 ? 지우고, 새로 저장하기 .
			map.put("current", "not liked");
			boardMapper.deleteLike(boardId, memberId);
		}else {
			map.put("current", "liked");
			boardMapper.insertLike(boardId, memberId);
		}
		
		int countAll = boardMapper.countLikeByBoardId(boardId);
		map.put("count", countAll);
		
		return map;
	}


	public Map<String, Object>  addCountViewByBoardId(int id) { 
		///board/get?id= 으로 인해. 페이지를 가져온다면	,조회수 1씩 증가 
		Map<String, Object> map = new HashMap<>();
		BoardDto board = boardMapper.selectBoardById(id);
		
		int count = 0;
		
		ViewDto view = viewMapper.selectViewDtoByBoardId(id);//존재하는 게시물의 뷰 카운트 가져와서 
		if(view == null) {
			//First insert
			viewMapper.insertViewTableById(id, count); // count == 0 을 넣어 첫 저장   ( boardId, 0 )  	
		}
		if(view != null && board != null ) {
			// 저장된 조회수를 가져오기 
			count = view.getCountView();
						
			//update
			count += 1; // 조회하면, 1 증가 -> update
			viewMapper.updateViewByBoardId(id, count);								
			
		}
		System.out.println(count );
		map.put("countView", count); // jsp ->java script-> fetch  json/ajax 사용하려고.
			
		return map;
	}


	
	
}
