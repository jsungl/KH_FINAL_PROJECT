package com.kh.nana.member.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.nana.member.model.vo.Member;

public interface MemberDao {

	Member selectOneMember(String id);
	
	Member selectOneMemberByEmail(String email);

	int insertMember(Member member);

	Member loadUserByUserEmail(String email);

	Member selectOneMemberByPhone(String phone);

	int updateMember(Member member);

	int selectTotalMember();

	List<Member> selectMemberList(Map<String, Object> page);

	int deleteMember(String memberId);

	

}
