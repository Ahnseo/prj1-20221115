package com.study.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.study.domain.board.ReplyDto;
import com.study.mapper.board.ReplyMapper;

@Component // 클래스를 빈으로 만듬 
public class ReplySecurity {

	@Autowired
	private ReplyMapper mapper;
	
	public boolean checkWriter(String username, int id) { // 사용자정보와 댓글 id
		
		ReplyDto reply = mapper.getReplyById(id);
		
		return reply.getWriter().equals(username);
	}
}
