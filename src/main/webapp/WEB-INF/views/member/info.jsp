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
<my:navBar active="memberInfo"></my:navBar>

<div class="container-md">
	<div class="row">
		<div class="col">
			<c:if test="${not empty message }"  >
			    <div class="alert alert-success">
			    	${message }
			    </div>
		  	</c:if>
			<h3>회원 정보 조회
				<c:url value="/member/modify" var="modifyLink">
					<c:param name="id" value="${member.id }" />
				</c:url>
				<a href="${modifyLink }"><i class="fa-regular fa-pen-to-square"></i><span style="font-size: 15px">수정하기</span></a> 
			</h3>
			<div class="row">
				<label for="staticId" class="col-sm-2 col-form-label">ID</label>
				<div class="col">
					<input type="text" value="${member.id }" readonly="readonly" class="form-control-plaintext" id="staticId">
				</div>
			</div>
			<div class="row">	
				<label for="staticPw" class="col-sm-2 col-form-label">비밀번호</label>
				<div class="col">
					<input type="text" value="${member.password }" readonly="readonly" class="form-control-plaintext" id="staticPw">
				</div>
			</div>
			<div class="row">	 
				<label for="staticName" class="col-sm-2 col-form-label">이름</label>
				<div class="col">
					<input type="text" value="${member.name }" readonly="readonly" class="form-control-plaintext" id="staticName">
				</div>
			</div>
			<div class="row">		
				<label for="staticNickName" class="col-sm-2 col-form-label">닉네임</label>
				<div class="col">
					<input type="text" value="${member.nickname }" readonly="readonly" class="form-control-plaintext" id="staticNickName">
				</div>
			</div>
			<div class="row">	
				<label for="staticEmail" class="col-sm-2 col-form-label">Email</label>
				<div class="col">
					<input type="text" value="${member.email }" readonly="readonly" class="form-control-plaintext" id="staticEmail">
				</div>
			</div>	
			<div class="row">	
				<label for="staticInserted" class="col-sm-2 col-form-label">가입일시</label>
				<div class="col">
					<input type="text"  value="${member.inserted }" readonly="readonly" class="form-control-plaintext" id="staticInserted">
				</div>
			</div>
		</div>
	</div>
</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>
</html>