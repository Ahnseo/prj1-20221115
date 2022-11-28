<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>      
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
	<my:navBar></my:navBar>
	<div class="container-md">
		<div class="row">
			<div class="col">
				<c:if test="${not empty message }"  >
				    <div class="alert alert-success">
				    	${message }
				    </div>
			  	</c:if>
				<h3>회원 정보 수정</h3>

				<form id="updateMemberForm" action="" method="post" >
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">ID<br>(변경불가)</label>
						</div>
						<div class="col-sm-3 ">
							<input type="text"  placeholder="${member.id }" class="form-control" disabled readonly>
						</div>
					</div>
					<br>
					
					<input type="checkbox" id="passwordCheckbox"> 비밀번호 변경
					
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">새 비밀번호</label>
						</div>
						<div class="col-sm-3 ">	
							<input type="password" name="password" value="" class="form-control" id="currentPassword"  disabled >
							<div id="pwConfirmtext1"></div>
						</div>
					</div>
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">새 비밀번호 확인</label>					
						</div>
						<div class="col-sm-3 ">
							<input type="password" class="form-control" id="pwConfirmInput" disabled>
							<div id="pwConfirmtext2"></div>
						</div>
					</div>
					<br>		
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">이름<br>(변경불가)</label>
						</div>
						<div class="col-sm-3 ">
							<input type="text"  value="${member.name }" class="form-control" disabled readonly>			
						</div>
					</div>	
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">닉네임</label>		
						</div>
						<div class="col-sm-3 ">
							<input type="text" name="nickname" value="${member.nickname }" class="form-control" id="nickNameInput" data-new-nickName="${member.nickname }">
							<input type="hidden" value="${member.nickname }" class="form-control" id="hiddenOldNickName" data-old-nickName="${member.nickname }">
							<button  id="existNickNameButton" type="button"  >중복확인</button>
							<div id="nickNameText"></div>
						</div>
					</div>						
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">Email</label>	
						</div>
						<div class="col-sm-3 ">
							<input id="emailInput" data-old-value="${member.email }" type="email" name="email" value="${member.email }" class="form-control">		
							<button  id="existEmailButton" type="button" disabled >중복확인</button>		
							<div id="emailText"></div>
						</div>
					</div>		 
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">가입일시<br>(변경불가)</label>
						</div>
						<div class="col-sm-3 ">
							<input type="text" value="${member.inserted }" class="form-control" disabled readonly>
						</div>
					</div>	
					<br>
					
					<%-- hidden 패스워드 hidden 에 name="" 쿼리스트링 주면 안돼!! 그냥 받아오는것뿐이야. --%>
					<input type="text" name="oldPassword" value="" id ="oldPasswordId" > 
					
					<%-- (수정 다시 물어보기) jsp => 모달  --%>
					<%-- <input type="submit" value="회원정보 수정"> --%>
				</form>
				
				<!-- 회원 탈퇴 form -->
				<c:url value="/member/remove" var="removeLink"/>
				<form id="removeMemberForm" action="${removeLink }" method="post" class="mb-3">
					<input type="hidden" name="id" value="${member.id }">
					<input type="hidden" id="oldPasswordByRemoveMemberInput" value="${member.password }"><%-- hidden 에 name="" 쿼리스트링 주면 안돼!! 그냥 받아오는것뿐이야. --%>
					<%-- (탈퇴 다시 물어보기) jsp 모달  --%>
					<%-- <input type="submit" value="회원 탈퇴"> --%>
				</form>
				<button id="updateMemberButton" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateMemberModal" disabled >회원 수정</button>
				<button id="removeMemberButton" type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#removeMemberModal" >회원 탈퇴</button>
			</div>
		</div>
	</div>
		
	<!-- 회원 탈퇴 모달 -->
	<div class="modal fade" id="removeMemberModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">회원 탈퇴</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	      	<input class="form-control" id="oldPasswordByRemoveMemberModalId" name="oldPassword" placeholder="탈퇴를 진행하시려면, 기존 비밀번호를 입력하세요.">
	      	<br>
	        회원 탈퇴 하시겠습니까?
	        <div id="failMessage">
	        </div>
	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	        <button id="removeMemberModalSubmit" type="button" class="btn btn-danger">탈퇴</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 회원 정보 수정 모달 -->
	<div class="modal fade" id="updateMemberModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">기존 암호 입력</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <input id="oldPasswordInput1" type="password" class="form-control" value="" >
	      	<br>
	        수정 하시겠습니까?
	        <br>
	        <div id="modifyModalText"></div>
	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	        <button id="updateMemberModalSubmit" type="button" class="btn btn-primary">수정</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	
	<script>
	const ctx = "${pageContext.request.contextPath}";
	
	const inputPw1 = document.querySelector("#currentPassword");
	const inputPw2 = document.querySelector("#pwConfirmInput");
	
	<!-- 회원정보 수정시,비밀번호 수정 체크박스  -->
	const passwordCheckbox = document.querySelector("#passwordCheckbox");
	passwordCheckbox.addEventListener("click",function(){
		if(passwordCheckbox.checked) {
			
			inputPw1.removeAttribute("disabled");
			inputPw2.removeAttribute("disabled");
		}else {
			inputPw1.setAttribute("disabled", "");
			inputPw2.setAttribute("disabled", "");
		}
		
	});
	
	
	<!-- 2차비번이 성공해야, 수정 버튼 ON/OFF -->
	let availablePw = false;	
	function updateSubmit(){
		if(availablePw){
			document.querySelector("#updateMemberButton").removeAttribute("disabled");	
		}else{
			document.querySelector("#updateMemberButton").setAttribute("disabled", "");
		}
	}
	
	<!-- 닉네임 변경 중복확인  -->
	document.querySelector("#nickNameInput").addEventListener("keyup", function(){
		
		const oldNickName = document.querySelector("#hiddenOldNickName").dataset.oldNickName;
		const newNickName = document.querySelector("#nickNameInput").value;		
		
		if(oldNickName == newNickName){
			document.querySelector("#nickNameText").innerText= "기존의 닉네임 입니다.";
			
		}else{
			document.querySelector("#nickNameText").innerText= "닉네임 중복을 확인하세요.";
						
			document.querySelector("#existNickNameButton").addEventListener("click", function(){
				
				fetch(ctx + "/member/existNickName", { method:"post", headers :{"Content-Type":"application/json"}, body : JSON.stringify({nickname : newNickName}) })
				.then(res => res.json())
				.then(data => {
					document.querySelector("#nickNameText").innerText = data.message;
					if(data.status == "not exist"){
						document.querySelector("#nickNameText").innerText= "사용가능한 닉네임 입니다.";
						
					}else{
					
						document.querySelector("#nickNameText").innerText= "중복된 닉네임 입니다.";	
						
					}
				});
			});
		}
	});
	
	<!-- 버그.. trim() 으로 빈스트링 제거해야해.. -->
	<!-- 패스워드 2차 확인 -->
		document.querySelector("#pwConfirmInput").addEventListener("keyup", function(){
			availablePw = false;
			const pw1 = document.querySelector("#currentPassword").value;
			const pw2 = document.querySelector("#pwConfirmInput").value;
			if(pw1 == pw2){
				document.querySelector("#pwConfirmtext2").innerText = "변경한 비밀번호와 일치합니다.";
				availablePw = true;
				updateSubmit();
			}else{
				document.querySelector("#pwConfirmtext2").innerText = "변결한 비밀번호와 일치하지 않습니다.";
			}
		});
		<!-- 패스워드 수정 변경 유무 확인 -->
		document.querySelector("#currentPassword").addEventListener("keyup", function(){
			const oldPassword = document.querySelector("#currentPassword").dataset.oldValue;
			const newPassword = document.querySelector("#currentPassword").value;
			if(oldPassword == newPassword){
				document.querySelector("#pwConfirmtext1").innerText = "기존의 비밀번호와 일치합니다.";
			}else{
				document.querySelector("#pwConfirmtext1").innerText = "비밀번호 확인을 입력하세요. ";
			}
		});
	
	
	<!-- 이메일 수정시, 중복확인 : disabled ON/OFF설정 -->
	document.querySelector("#emailInput").addEventListener("keyup", function(){
		//기존 이메일과 일치하며, 아무일 없고,
		//기존 이메일과 다른 값을 입력하면 -> 중복확인해주세요 innerText 출력
		const oldValue = document.querySelector("#emailInput").dataset.oldValue;
		const newValue = document.querySelector("#emailInput").value;
		
		if(oldValue == newValue){
			document.querySelector("#emailText").innerText = "";
			document.querySelector("#existEmailButton").setAttribute("disabled", "disabled");
			
		}else{
			document.querySelector("#emailText").innerText = "중복확인 해주세요.";
			document.querySelector("#existEmailButton").removeAttribute("disabled");		
		}
	});
	
	<!-- 이메일 중복확인  -->
	document.querySelector("#existEmailButton").addEventListener("click", function(){
		const newValue = document.querySelector("#emailInput").value;
		console.log(newValue);
		
		fetch(ctx + "/member/existEmail" , {
			method : "post",
			headers : {"Content-Type" : "application/json"},
			body : JSON.stringify({email : newValue})
		})
		.then(res => res.json())
		.then(data => document.querySelector("#emailText").innerText = data.message )
	});
	
	
	
	<!-- 회원 탈퇴 모달 -->
	document.querySelector("#removeMemberButton").addEventListener("click", function(){
		//모달 암포 인풋 입력되 값을 -> 폼 안의 기존암호 인풋에 옴기고 -> 폼을 서브밋
		const removeMemberForm = document.forms.removeMemberForm;
		const oldPasswordByRemoveMemberInput = document.querySelector("#oldPasswordByRemoveMemberInput");
		console.log(oldPasswordByRemoveMemberInput.value); // 암호화된 기존의 비밀번
		
		const oldPasswordByRemoveMemberModalInput = document.querySelector("#oldPasswordByRemoveMemberModalId");
		console.log(oldPasswordByRemoveMemberModalInput.value);  //너가 문제야. json으로 보낼거야 .
		
		document.querySelector("#removeMemberModalSubmit").addEventListener("click", function(){
			
			fetch(ctx + "/member/remove", { method:"post", headers:{"Content-Type":"application/json"}, body:JSON.stringify( {oldPassword, oldPasswordByRemoveMemberModalInput.value} ) })	
			.then(res => res.json())
			.then(data => { 	
				
				console.log(data);
				
				if (oldPasswordByRemoveMemberInput == data) {
					document.querySelector("#removeMemberForm").submit();
				}else{
					document.querySelector("#failMessage").innerHTML = "비밀번호가 일치하지 않습니다.";
				}
				
			});
		});
	});
	
	<!-- 회원 정보 수정 모달 -->
	document.querySelector("#updateMemberModalSubmit").addEventListener("click", function(){
		//모달 암포 인풋 입력되 값을 -> 폼 안의 기존암호 인풋에 옴기고 -> 폼을 서브밋
		const updateMemberForm = document.forms.updateMemberForm;
		const modalInput1 = document.querySelector("#oldPasswordInput1");
		const oldPasswordInput = document.querySelector("#oldPasswordId");
		
		
		// 모달 암호 input 입력된 값을 
		// form 안의 기존암호 input에 옮기고
		
		oldPasswordInput.value = modalInput1.value;	
		
		console.log(oldPasswordInput);
		
		updateMemberForm.submit();
	
	});
	
	</script>
	

</body>
</html>