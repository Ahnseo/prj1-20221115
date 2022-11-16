package com.study.mapper.member;

import java.util.List;

import com.study.domain.member.MemberDto;



public interface MemberMapper {

	int insertMember(MemberDto member);

	List<MemberDto> selectMemberList();

	MemberDto selectMemberInfoById(String id);

	int updateMemberInfo(MemberDto member);

	int deleteMemberById(String id);

	MemberDto selectMemberByEmail(String email);

	MemberDto selectMemberByNickName(String nickname);

}
