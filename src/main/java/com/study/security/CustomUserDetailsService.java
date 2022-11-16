package com.study.security;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.study.domain.member.MemberDto;
import com.study.mapper.member.MemberMapper;

@Component //빈을 만들기 위해 컴포넌
public class CustomUserDetailsService implements UserDetailsService {

	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		MemberDto member = memberMapper.selectMemberInfoById(username);
		if(member == null){
			return null;
		}else {
			
			String encodedPw = passwordEncoder.encode(member.getPassword() );
			User user = new User(member.getId(), encodedPw, List.of()); //import org.springframework.security.core.userdetails.User;
			
			return user;
		}
		
	}
}