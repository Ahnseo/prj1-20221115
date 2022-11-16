package com.study.mapper.board;

import java.util.List;

import com.study.domain.board.BoardDto;



public interface BoardMapper {
	
						 //xml에 들어갈 파라미터 순서 잘 지켜라
	List <BoardDto> list (int offset, int records, String keyword, String type);

	int insertBoard(BoardDto board);			

	BoardDto selectBoardById(int id);
	
	int update(BoardDto board );

	int remove(int id);

	int countAll(String keyword, String type);
	
	
	int insertFile(int boardId, String fileName);

	int updateFile(int boardId, String fileName);


	int deleteFilesByBoardId(int id);

	int deleteFileByBoardIdAndFileName(int boardId, String fileName);

}
