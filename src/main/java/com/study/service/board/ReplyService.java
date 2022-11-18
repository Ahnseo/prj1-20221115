package com.study.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.domain.board.ReplyDto;
import com.study.mapper.board.ReplyMapper;


@Service
public class ReplyService {

	@Autowired
	private ReplyMapper mapper;
	
	public int addReply(ReplyDto reply) {
		return mapper.insert(reply);	
	}

	public List<ReplyDto> listReplyByBoardId(int boardId, String username) {	
		return mapper.selectReplyByBoardId(boardId, username);
	}

	public int removeReply(int id) {
		return mapper.removeReply(id);
	}
	
	public int modifyReply(ReplyDto reply) {
		return mapper.updateReply(reply);
	}

	public ReplyDto getReplyById(int id) {
		
		return mapper.getReplyById(id);
	}




}
