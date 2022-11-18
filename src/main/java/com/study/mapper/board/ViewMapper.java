package com.study.mapper.board;

import com.study.domain.board.ViewDto;

public interface ViewMapper {
	
	int insertViewTableById(int boardId, int defaultValue);

	int updateViewByBoardId(int boardId, int countView);

	ViewDto selectViewDtoByBoardId(int boardId);
}
