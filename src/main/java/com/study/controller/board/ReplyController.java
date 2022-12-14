package com.study.controller.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.domain.board.ReplyDto;
import com.study.service.board.ReplyService;

@Controller
@RequestMapping("reply")
public class ReplyController {

	@Autowired
	private ReplyService service;
	
	@PostMapping("add")
	@ResponseBody
	@PreAuthorize("isAuthenticated()")//어노테이션 로그인 권
	public Map<String, Object> add (@RequestBody ReplyDto reply, Authentication authentication) {
		
//		if(authentication != null) {
		reply.setWriter(authentication.getName() ); //로그인한 아이디가 댓글에 대한 권한을 갖음. 위의 @preAuthorize("isAuthenticated()")적용
//		}
		
		Map<String, Object> map = new HashMap<>();
		int cnt = service.addReply(reply);
		if (cnt == 1) {
			map.put("message", "새 댓글이 등록되었습니다.");
			
		}else {
			map.put("message", "새 댓글이 등록되지 않았습니다.");
		}
		return map;
	}
	
	@GetMapping("list/{boardId}")
	@ResponseBody
	public List<ReplyDto> list(@PathVariable int boardId, Authentication authentication){
		
		String username = "";
		if(username != null) { //로그인 아이디와 같다면, 실행 
			username = authentication.getName();
		}
		System.out.println("username : " + username);
		return service.listReplyByBoardId(boardId, username);
	}
	
	@DeleteMapping("remove/{id}")
	@ResponseBody
	public Map<String, Object> remove(@PathVariable int id) {
		
		Map<String, Object> map = new HashMap<>();
		
		int cnt = service.removeReply(id);
		
		if (cnt == 1) {
			map.put("message", "댓글이 삭제되었습니다.");
			
		}else {
			map.put("message", "댓글이 삭제되지 않았습니다.");
		}
		return map;
	}
	
	@GetMapping("get/{id}")
	@ResponseBody
	public ReplyDto getReplyById(@PathVariable int id){

		return service.getReplyById(id);
	}
	
	@PutMapping("modify")
	@ResponseBody
	@PreAuthorize("@replySecurity.checkWriter(authentication.name, #reply.id)")
	public Map<String, Object> modifyReply(@RequestBody ReplyDto reply ){
		
		
		
		Map<String, Object> map = new HashMap<>();
		int cnt = service.modifyReply(reply);
		
		if (cnt == 1) {
			map.put("message", "댓글이 수정되었습니다.");
		}else {
			map.put("message", "댓글이 수정되지 않았습니다.");
		}
		return map;
	}
	
	
}
