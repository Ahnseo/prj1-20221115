package com.study.service.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.study.domain.member.MemberDto;
import com.study.mapper.member.MemberMapper;

@Service
public class MemberService {

	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	public int insertMember(MemberDto member) {
		 
		member.setPassword( passwordEncoder.encode( member.getPassword() ) );
		
		int cnt = memberMapper.insertMember(member);	
		return cnt;	
	}

	public List<MemberDto> memberList() {
		
		return memberMapper.selectMemberList();
	}

	public MemberDto memberInfoById(String id) {
		
		return  memberMapper.selectMemberInfoById(id);
	}

	public int modifyMemberInfo(MemberDto member) {
		
		int cnt = 0;
		
		try {
			cnt = memberMapper.updateMemberInfo(member);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return cnt;
	}

	public int removeMemberById(String id) {
		System.out.println(id);
		return  memberMapper.deleteMemberById(id);
		
	}

	public MemberDto selectMemberByEmail(String email) {
		
		return memberMapper.selectMemberByEmail(email);
	}

	public MemberDto existNickNameConfirm(String nickname) {
		return memberMapper.selectMemberByNickName(nickname);
		
	}

	
}
