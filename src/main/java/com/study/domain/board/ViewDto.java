package com.study.domain.board;

import lombok.Data;

@Data
public class ViewDto {
	private int id;
	private int boardId;
	private int countView; 
}
