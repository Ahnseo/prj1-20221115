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
	<%-- tag_navbar_active: 경로 이동해줌 --%>
	<my:navBar active="signup"></my:navBar>
	<div>
		${message }
	</div>
	
	<div class="container-md">
		<div class="row">
			<div class="col">
				<h3>회원 가입</h3>
				
				<form action="" method="post">
					<div class="row  input-group" >
						<div class="col-sm-2 ">
							<label for="staticId" class="form-label">ID</label>
						</div>
						<div class="col-sm-3">
							<input id="userIdInput" type="text" name="id" value="${member.id }" class="form-control" id="staticId">
							<div id="userIdText">아이디 중복확인을 해주세요.</div>
							<button id="userIdExistButton" class="btn btn-outline-secondary" type="button">중복확인</button>
						</div>
					</div>		
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label  class="form-label">비밀번호</label>					
						</div>
						<div class="col-sm-3 ">
							<input type="text" name="password" value="${member.password }" class="form-control" id="pwInput1">
						</div>
					</div>		
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label class="form-label">비밀번호 확인</label>					
						</div>
						<div class="col-sm-3 ">
							<input type="text" class="form-control" id="pwInput2">
							<div id="pwConfirmtextDiv"></div>
						</div>
					</div>
					<br>		
					<div class="row">
						<div class="col-sm-2 ">
							<label for="staticName" class="form-label">이름</label>
						</div>
						<div class="col-sm-3 ">	
							<input type="text" name="name" value="${member.name }" class="form-control" id="staticName">
						</div>
					</div>			
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label for="" class="form-label">닉네임</label>
						</div>
						<div class="col-sm-3 ">
							<input type="text" name="nickname" value="${member.nickname }" class="form-control" id="nickNameinput">
							<div id="nickNameText">닉네임 중복확인을 해주세요.</div>
							<button id="nickNameExistButton" class="btn btn-outline-secondary" type="button">중복확인</button>
						</div>
					</div>
					<br>
					<div class="row">
						<div class="col-sm-2 ">
							<label for="exampleDataList" class="form-label">Email</label>
						</div>	
						<div class="col-sm-3" id="exampleEmailListInput" >
							<input id="userEmailExistInput" type="email" name="email" value="${member.email }" class="form-control" list="datalistOptions" placeholder="abc@gmail.com">
							<div id="userEmailText">이메일 중복확인을 해주세요.</div>
							<button id="userEmailExistButton" class="btn btn-outline-secondary" type="button">중복확인</button>
							<datalist id="datalistOptions">		
								<option id="ex1"  value="">
								<option id="ex2"  value="">
								<option id="ex3"  value="">
								<option id="ex4"  value="">
							</datalist>
						</div>
					</div>
					<br>
					<input id="confirmSubmitButton"  type="submit" value="회원가입" disabled >
					
				</form>
				
			</div>
		</div>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script>
	const ctx = "${pageContext.request.contextPath}"
	
	let availableId = false;
	let availablePw = false;
	let availableEmail = false;
	let availableNickname = false;
	
	//nickName input 변경시 버튼 비활성화 
	document.querySelector("#nickNameinput").addEventListener("keyup", function() {
		availableNickname = false;
		signUpSubmit();
	});
	
	//id input 변경시 submit 버튼 비활성화
	document.querySelector("#userIdInput").addEventListener("keyup", function() {
		availableId = false;
		signUpSubmit();
	});
	//email input 변경시 submit 버튼 비활성화
	document.querySelector("#userEmailExistInput").addEventListener("keyup", function(){
		availableEmail = false;
		signUpSubmit();
	});
	
	
	
	<%-- 가입 disabled : ON/OFF --%>
	function signUpSubmit (){
		
		const button = document.querySelector("#confirmSubmitButton");
		console.log(availableId);
		console.log(availablePw);
		console.log(availableEmail);
		
		if(availableId && availablePw && availableEmail && availableNickname){
			button.removeAttribute("disabled");
		}else{
			button.setAttribute("disabled","disabled");
		}	
	}
	<%-- nickName 중복확인 --%>	
	document.querySelector("#nickNameExistButton").addEventListener("click", function(){
		const nickNameValue = document.querySelector("#nickNameinput").value;
		fetch(ctx + "/member/existNickName", {
				method : "post",
				headers : {"Content-Type" : "application/json"},
				body : JSON.stringify({ "nickname" : nickNameValue }) 
			})
		.then(res => res.json())
		.then(data => {
			document.querySelector("#nickNameText").innerText = data.message;
			
			if(data.status == "not exist") {
				document.querySelector("#nickNameText").innerText = data.message;
				availableNickname = true;
			}else {
				document.querySelector("#nickNameText").innerText = data.message;
			}
			signUpSubmit();
		})
	});
	
	<%-- Email 중복확인 --%>
	document.querySelector("#userEmailExistButton").addEventListener("click", function(){
		availableEmail = false;
		const emailValue = document.querySelector("#userEmailExistInput").value; 
		fetch(ctx + "/member/existEmail", {
			method : "post",
			headers : {"Content-Type":"application/json"},
			body : JSON.stringify({email : emailValue}) 
		})
		.then(res => res.json())
		.then(data => {
			document.querySelector("#userEmailText").innerText = data.message;
			if(data.status == "not exist"){
				availableEmail = true;		
				signUpSubmit();
			}
		});
	});
	
	<%-- 아이디 중복확인 --%>
	document.querySelector("#userIdExistButton").addEventListener("click", function(){
		availableId = false;
		//입력된 유저id -> fetch -> 응답받아서 message출력
		const userIdValue = document.querySelector("#userIdInput").value;
		fetch(ctx + "/member/existId/" + userIdValue)
		.then(res => res.json())
		.then(data => {
			document.querySelector("#userIdText").innerText = data.message;//응답 받아서 어떤 일을한다
			if(data.status == "not exist"){
				availableId = true;
				signUpSubmit();
			}
		});
	});
	
	
	<%-- 패스워드 일치하는지 --%>
	const pwInput1 = document.querySelector("#pwInput1");
	const pwInput2 = document.querySelector("#pwInput2");
	
	pwInput1.addEventListener("keyup", matchPassword);
	pwInput2.addEventListener("keyup", matchPassword);
	
	function matchPassword(){
		availablePw = false;
		
		const pwConfirmtextDiv = document.querySelector("#pwConfirmtextDiv"); 
		
		if( pwInput1.value == pwInput2.value){
			pwConfirmtextDiv.innerText = "비밀번호가 일치합니다.";
			
			availablePw = true;
			
		}else{
			pwConfirmtextDiv.innerText = "비밀번호가 일치하지 않습니다.";
			
		}
		signUpSubmit();
	}
	
	
	<%--  --%>
		document.querySelector("#exampleEmailListInput").addEventListener('mouseover', (event) => {
			document.querySelector("#ex1").value = "@gmail.com";
			document.querySelector("#ex2").value = "@naver.com";
			document.querySelector("#ex3").value = "@daum.net";
			document.querySelector("#ex4").value = "@nate.com";
			
			
		});
	</script>
	
	</body>
</html>