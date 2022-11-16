package com.study.controller.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.study.domain.board.BoardDto;
import com.study.domain.board.PageInfo;
import com.study.service.board.BoardService;


@Controller
@RequestMapping("board")
public class boardController {

	@Autowired
	private BoardService service;
	
	@PostMapping("register")
	public String register(
			BoardDto board,
			RedirectAttributes rttr,
			MultipartFile[] files) {
		// 잘 동작하는지?
		System.out.println(board);
		System.out.println(files.length);			
		for(MultipartFile file : files) {
			System.out.println(file.getOriginalFilename());
		}
		// *파일 업로드 : 1. web.xml multipart-config 추가 / 2.form의 enctype="multipart/form-data" / 3.Controller의 메소드 argument type:MultipartFile
		
		// 비지니스 로직(Service)
		int cnt = service.register(board, files);
		
		if (cnt==1) {
			rttr.addFlashAttribute("message", "새 게시물이 등록되었습니다.");
		}else {
			rttr.addFlashAttribute("message", "새 게시물이 등록되지 않았습니다.");
		}	
		// /board/list 로 redirect
		return "redirect:/board/list";
	}

	// board/register
	@GetMapping("register")
	public void register() {
		// forward -> list register (게시물 작성 view로 바로 포워딩)
		// WEB-INF/views/board/register
		
	}

	@GetMapping("list")
	public void list(
			// request parameter 수집 가공
			@RequestParam(name = "t" ,defaultValue = "all") String type,
			@RequestParam(name = "q" , defaultValue = "") String keyword,
			@RequestParam(name = "page", defaultValue = "1") int page, // default ="1" 필요해서 생략하지 않고 코드 작성.  
			PageInfo pageInfo, //@ModelAttribute(name="pageInfo") 생략됨, "pageInfo" auto create & add Attribute 
			Model model 
			) {
		
		// business logic : service 메소드 실행 
		List<BoardDto> list = service.listBoard(page, pageInfo, keyword, type);
							
		// add attribute -> list.jsp el코드
		model.addAttribute("boardList", list);
		
		
		// void type forward -> views/list.jsp
	}
	
	@GetMapping("get")
	public void getBoardById(Model model ,@RequestParam(name = "id") int id) { 
					            //@RequestParam(name = "id") 생략가능
		//req param
		//비지니스 로직 (db에서 게시물 가져오기)
		BoardDto board = service.getBoardById(id);
		System.out.println(board); //콘솔 확인
		
		//add attribute
		model.addAttribute("board", board);
		
		//forward / redirect
		//get.jsp		
	}
	
	@GetMapping("modify")
	public void modify(Model model, int id) {
		BoardDto board = service.getBoardById(id);
		model.addAttribute("board", board);
	}
	
	@PostMapping("modify")
	public String modify(
			BoardDto board,
			RedirectAttributes rttr,
			@RequestParam(name = "files") MultipartFile[] addFiles,
			@RequestParam(name="removeFile", required = false) List<String> removeFiles
			) {
		//System.out.println(files.length);			
		//for(MultipartFile file : files) {
		//	System.out.println(file.getOriginalFilename());
		//}			
					
		
		int cnt = service.update(board, addFiles, removeFiles);
		if (cnt==1) {
			rttr.addFlashAttribute("message", board.getId() + "번 게시물이 수정되었습니다.");
		}else {
			rttr.addFlashAttribute("message", board.getId() +"번 게시물이 수정되지 않았습니다.");
		}
		return "redirect:/board/list";
	}
	
	@PostMapping("remove")
	public String remove(int id, RedirectAttributes rttr) {
		int cnt = service.remove(id);
		if (cnt==1) {
			rttr.addFlashAttribute("message", id + "번 게시물이 삭제 되었습니다.");
		}else {
			rttr.addFlashAttribute("message", id + "번 게시물이 삭제되지 않았습니다..");
		}
		return "redirect:/board/list";
	}
	
	
}




