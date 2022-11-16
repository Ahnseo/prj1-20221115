<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags"%>

<%-- URLEncoder 패키지를 import --%>
<%@ page import="java.net.*" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />	
	
	<style>
		.flex-row-reverse{
			display : flex;
			flex-direction: row-reverse;
		}
	</style>
</head>
<body>
	<div>
		<my:navBar/>
	</div>
	<div class="container-md">
	  <div class="row">
	   <div class="col">   
		<h3>${board.id }번 게시물 수정</h3>	
		
		<form id="modifyForm" action="" method="post" enctype="multipart/form-data">
		  <input type="hidden" name="id" value="${board.id }">
		  <div>
		    <label for="" class="form-label">제목</label>
		  </div>
		  <input class="form-control" type="text" name="title" value="${board.title }">
		 
		  <div>
			<label for="" class="form-label">본문</label>
		  </div>	
		  <textarea class="form-control mb-3" name="content">${board.content }</textarea>
		  <%-- 이미지 출력 div --%>
		  <div class="mb-3">
			<c:forEach items="${board.fileName}" var="fileName" varStatus="status">
			  <div class="row">
			  	<div class="col-2">
				<!-- 체크박스 bootstrap -->
			  	  <div class="form-check form-switch">
					  <input name="removeFile" value="${fileName}" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault${status.count }">
					  <label class="form-check-label" for="flexSwitchCheckDefault${status.count }"><i class="fa-regular fa-trash-can"></i></label>
				  </div>
			  	</div>
				<div class="mb-5">
				  <img class="img-fluid img-thumbnail" src="${imgUrl }/${board.id }/${URLEncoder.encode(fileName, 'utf-8')}" alt="" >
				</div>
			  </div>
		  	</c:forEach>
		  </div>
		  <div class="mb-3">
	        <label for="" class="form-label">파일 추가</label>
		    <input multiple="multiple" type="file" accept="image/*" class="gorm-control" name="files">
		    <div class="form-text" id="addFileInputText">
		    		
		   	</div>
	      </div> 
		
		  <div class="mb-3">
			<label for="" class="form-label">작성자</label>
		    <input class="form-control" type="text" name="writer" value="${board.writer }">	
		  </div>	
		  
		  <div>
			<label for="" class="form-label">작성일시</label>  
	 		<input class="form-control" type="datetime-local" value="${board.inserted }" readonly>
		  </div>	
		</form>
		 
		<div class="flex-row-reverse">
			<c:url value="/board/remove" var="removeLink"/>
			<form id="removeForm" action="${removeLink }" method="post">
				<input type="hidden" name="id" value="${board.id }"> 
				<input type="submit" value="삭제하기" data-bs-toggle="modal" data-bs-target="#removeModal">
			</form>
			
			<input  class="" type="submit" value="수정하기" data-bs-toggle="modal" data-bs-target="#modifyModal">
		</div> 
		
		<!-- modify Modal -->
		<div class="modal fade" id="modifyModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		      </div>
		      <div class="modal-body">
		        수정하시겠습니까?
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
		        <button type="button" class="btn btn-primary" id="modifyConfirmButton" >확인</button>
		      </div>									<!-- id="modifyConfirmButton" 여기에 id설정 -->			
		    </div>
		  </div>
		</div>
	

		
		<!-- removeModal -->
		<div class="modal fade" id="removeModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		      </div>
		      <div class="modal-body">
		        삭제하시겠습니까?
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
		        <button type="button" class="btn btn-danger"    id="removeConfirmButton">삭제</button>
		      </div>                                       <!--  id="removeConfirmButton" 여기에 id설정 -->
		    </div>
		  </div>
		</div>
	    </div>
	  </div>
	
	 
	</div>
	
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous">
	</script>
		
	<script>
		/*
		파일 업로드를 시도할때, 이미 있는 파일명을 선택하였다면, <div>"중복된 파일이 있습니다"</div> 출력하고 싶다...
		어려워서 오늘은 Pass...
		
		document.querySelector(`#modifyForm input[name="files"]`).addEventListener("click", function(){
			
			const textDiv = document.querySelector("#addFileInputText");
			textDiv.innerHTML = ""; //textDiv 초기화
			
			// 검증
			// 추가할 파일명 input:files 에서 선택한 파일명
			// 이미 등록된 파일명들. `#modifyForm input[name="files"]` 의 value 들 과 비교해서 중보되는게 있으면 ok =false;
			
			const modifyFiles = document.querySelectorAll(`#modifyForm input[name="files"]`).forEach().Array.from();
			console.log(modifyFiles);	
		});
		*/
			
			
		
	
		document.querySelector("#modifyConfirmButton").addEventListener("click", function(){
			document.querySelector("#modifyForm").submit();
		});
		
		document.querySelector("#removeConfirmButton").addEventListener("click", function(){
			document.querySelector("#removeForm").submit();
		});
	</script>	
</body>

</html>