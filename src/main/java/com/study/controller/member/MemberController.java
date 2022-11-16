package com.study.controller.member;


import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.study.domain.member.MemberDto;
import com.study.service.member.MemberService;


@Controller
@RequestMapping("member")
public class MemberController {
	
	
	@Autowired
	private MemberService memberService;
	
	@GetMapping("signup")
	public void signup() {
		//void 포워드 일 함
	}
	
	@PostMapping("signup")
	public String signupPost(@ModelAttribute(name="member") MemberDto member,
							RedirectAttributes rttr){
		//System.out.println(member);
		
		int cnt = memberService.insertMember(member);
		
		if (cnt == 1) {
			rttr.addFlashAttribute("message", "회원가입 되었습니다.");
			return "redirect:/board/list";
		}else {
			
			rttr.addFlashAttribute("message", "회원가입에 실패하였습니다.");
			return "redirect:/member/signup";
		}
	}
	
	@GetMapping("existId/{id}")
	@ResponseBody
	public Map<String, Object> existIdCheck(@PathVariable String id) {
		MemberDto member = memberService.memberInfoById(id);
		
		Map<String, Object> map = new HashMap<>();
		if(member != null) {
			map.put("message", "중복된 아이디 입니다.");
			map.put("status", "exist");
			
		}else {
			map.put("message", "사용가능한 아이디 입니다.");
			map.put("status", "not exist");
		}
		return map;

	}
	
	@PostMapping("existEmail")
	@ResponseBody
	public Map<String, Object> existEmail(@RequestBody Map<String , String> request){
		
		System.out.println(request.get("email")); //@RequestBody 로 받은 email(key) = 무엇인지(value) 얻기위해 
		
		MemberDto member = memberService.selectMemberByEmail(request.get("email"));

		
		 Map<String, Object> map = new HashMap<String, Object>();
		 
		 if(member != null) {
			 map.put("message", "중복된 이메일 입니다.");
			 map.put("status", "exist");
			 
		 }else {
			 map.put("message", "사용가능한 이메일 입니다.");
			 map.put("status", "not exist");
		 }
		 return map;
	}
	@PostMapping("existNickName")
	@ResponseBody
	public Map<String, Object> existNickNameConfirm(@RequestBody Map<String, String> nickname, Model model){
		Map<String, Object> map = new HashMap<>();
		MemberDto member = memberService.existNickNameConfirm(nickname.get("nickname"));
		
		if(member != null) {
			 map.put("message", "중복된 닉네임 입니다.");
			 map.put("status", "exist");
			 model.addAttribute("previousNickName", member.getNickname());
		}else {
			 map.put("message", "사용가능한 닉네임 입니다.");
			 map.put("status", "not exist");
		}
		return map;
	}
	
	
	@GetMapping("list") //read
	public void memberListGet(Model model) {
		model.addAttribute("memberList", memberService.memberList());

	}
	
	@GetMapping( {"info", "modify"} ) //{"info", "modify"} 둘다 하는일이 같아서.
	public void memberInfoById(String id, Model model) {
		MemberDto memberInfo = memberService.memberInfoById(id);
		model.addAttribute("member", memberInfo);
		
	};
	
	@PostMapping("modify")
	public String modifyMemberInfo( MemberDto member, RedirectAttributes rttr) {
		int cnt = memberService.modifyMemberInfo(member);
		rttr.addAttribute("id", member.getId());
		
		if(cnt == 1) {
			rttr.addFlashAttribute("message", "회원정보가 수정되었습니다.");
			return "redirect:/member/info";
		}else {
			rttr.addFlashAttribute("message", "회원정보가 수정되지 않았습니다.");
			return "redirect:/member/modify";
		}
	}
	
	@PostMapping("remove")
	public String removeMemberById(@RequestParam(name="id")String id, RedirectAttributes rttr) {
		//System.out.println(id);
		memberService.removeMemberById(id);
		
		rttr.addFlashAttribute("message", "회원 탈퇴 되었습니다.");			
		
		return "redirect:/board/list";
	}
	
	@GetMapping("login")
	public void login() {
		// TODO Auto-generated method stub

	}
	@GetMapping("logout")
	public String logout() {
		return "redirect:/board/list";

	}
	
	
}
