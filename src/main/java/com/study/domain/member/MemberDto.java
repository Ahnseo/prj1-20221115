package com.study.domain.member;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class MemberDto {
	
	//추가 할것.. 성명, 닉네임, 주민번호..?
	
	
	private String id;
	private String password;
	private String name;
	private String nickname;
	private String email;
	
	
	private List<String> auth;

	private LocalDateTime inserted;
	
}
