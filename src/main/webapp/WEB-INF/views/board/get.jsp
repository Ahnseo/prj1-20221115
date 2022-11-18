<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>      
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%-- URLEncoder 패키지를 import --%>
<%@ page import="java.net.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>

</style>
</head>
<body>
	<div>
		<my:navBar/>
	</div>
	
	<div class="container-md">
	  <div class="row">
	   <div class="col">
	   		<div class="d-flex">
				<h1>	
					<c:url value="/board/modify" var="modifyLink">
						<c:param name="id" value="${board.id }"></c:param>
					</c:url>
					${board.id }번 게시물 
					<sec:authorize access="isAuthenticated()">
						<a class="btn-btn-warning" href="${modifyLink }">수정<i class="fa-solid fa-pen-to-square"></i></a>
					</sec:authorize>
				</h1>
				
				<div class="d-flex flex-row-reverse">
					<h1 class="p-2">
						<span id="likeButton"><i class="fa-regular fa-thumbs-up"></i></span>
						<span id="likeCount">${board.countLike}</span>
					</h1>
					<h1 class="p-2"> 
						<span>조회수 ${view}</span>
					</h1>
				</div>
			</div>
		<div class="mb-3">
			<label for="" class="form-label">
				제목 
			</label>
		</div>
		
		
		<input class="form-control" type="text" name="title" value="${board.title }" readonly> 
		<div class="mb-3">
			<label for="">본문</label>
		</div>
		<textarea class="form-control" rows="5" cols="50" name="content" readonly >${board.content }</textarea> 
		
		<%-- 이미지 출력 div --%>
		<div>
			<c:forEach items="${board.fileName}" var="fileName">
				<div>
				<%-- https://spring-study-bucket-2022-11-10-ahnseoj.s3.ap-northeast-2.amazonaws.com/prj1/board/131600/%EB%B9%84%ED%8B%80%EC%A6%88.jpg --%>
				<%-- /spring20221017/src/main/java/org/zerock/listener/CustomApplicationListener.java 파일에 초기설정함. 
				imgURL = https://spring-study-bucket-2022-11-10-ahnseoj.s3.ap-northeast-2.amazonaws.com/prj1/board --%>
					<img class="img-fluid img-thumbnail" src="${imgUrl }/${board.id }/${URLEncoder.encode(fileName, 'utf-8')}" alt="" >
				</div>
			</c:forEach>
		</div>
		
		<div>
			<label for="" class="form-label">작성자</label>
		</div>
		<input class="form-control" type="text" name="writer"  value="${board.writer }" readonly> 
		<div>
			<label for="" class="form-label">작성일시</label>
		</div>
		<input class="form-control" type="datetime-local" name="inserted" value="${board.inserted }" readonly> 
	   </div>
	  </div>
	</div>
	
	<div class="container-md">
		<div class="row">
			<div class="col">
				<input type="hidden" id="boardId" value="${board.id }">
				<div id="replyMessage">
					${message }
				</div>
				<sec:authorize access="isAuthenticated()">
							<input type="text" id="replyInput1" value="">
							<button id="replySendButton1">댓글쓰기</button>
				</sec:authorize>
				<sec:authorize access="not isAuthenticated()">
					댓글을 작성하시려면 로그인 해주세요.
				</sec:authorize>
			</div>
		</div>
		
		<div class="row mt-3">
			<div class="col">
				<%--댓글 리스트 --%>
				<div id="replyListContainer">
				</div>
			</div>
		</div>				
	</div>

	<!-- 삭제 Modal -->
<div class="modal fade" id="removeReplyConfirmModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="exampleModalLabel">댓글 삭제</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        삭제 하시겠습니까?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger" id="removeConfirmModalSubmitButton" data-bs-dismiss="modal">삭제</button>
      </div>
    </div>
  </div>
</div>

	<!-- 수정 Modal -->
<div class="modal fade" id="modifyReplyConfirmModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="exampleModalLabel">댓글 수정</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      	<input type="text" id="modifyReplyInput">
      	<br>
        수정 하시겠습니까?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="modifyFormModalSubmitButton" data-bs-dismiss="modal">수정</button>
      </div>
    </div>
  </div>
</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	
	<script>
		const contextPath = "${pageContext.request.contextPath}";
		
		
		//좋아요 버튼 클릭시
		document.querySelector("#likeButton").addEventListener("click", function(){
			const boardId = document.querySelector("#boardId").value;
			fetch(contextPath + "/board/like", {
				method:"put",
				headers :{"Content-Type":"application/json"},
				body:JSON.stringify({boardId:boardId})
				})
				.then(res => res.json() )
				.then(data => {
					document.querySelector("#likeCount").innerText = data.count ;
					if(data.current == "liked") {
						document.querySelector("#likeButton").innerHTML = `<i class="fa-solid fa-thumbs-up"></i>`
					}else {
						document.querySelector("#likeButton").innerHTML = `<i class="fa-regular fa-thumbs-up"></i>`
					}
				})
			});
		
		listReply();
		
		// 모달에 기존의 reply content를 읽고, 붙여넣는 기능 만들기
		// readReplyAndSetModalForm(this.dataset.replyId); 일때,
		// response 값을 json으로 ,
		// 그 바뀐 값의 bean형식의 data.content 값을 #modifyReplyInput 속에 넣기
		function readReplyAndSetModalForm(id){
			fetch(`\${contextPath}/reply/get/\${id}`) 
			.then(res => res.json())
			.then(data => {
				document.querySelector("#modifyReplyInput").value = data.content });
		};
		//댓글 수정 하면, 데이터에 저장하고, 리스트 초기화
		document.querySelector("#modifyFormModalSubmitButton").addEventListener("click", function(){
			const content = document.querySelector("#modifyReplyInput").value;
			const id = this.dataset.replyId;
			const data = {id, content};
			
			fetch(`\${contextPath}/reply/modify`, { method:"put", headers : {"Content-Type" : "application/json"}, body : JSON.stringify(data) })
			.then(res => res.json()).then( data => { document.querySelector("#replyMessage").innerText = data.message })
			.then(() => listReply());
		});
		
		
		<!-- 댓글 리스트  -->
		function listReply(){
			const boardId = document.querySelector("#boardId").value;	
			console.log(boardId);
			fetch(contextPath + "/reply/list/" + boardId)
			.then(res => res.json())
			.then(list => {
				document.querySelector("#replyListContainer").innerHTML ="";//리스트 컨테이너 초기화

				for( const item of list ){
					//console.log(item.id);
					const modifyReplyButtonId = `modifyReplyButton\${item.id}`;//각각의 variable id 주기 
					const removeReplyButtonId = `removeReplyButton\${item.id}`;//각각의 variable id 주기
					const editButton = 
						`<div>
							<button
								data-bs-toggle="modal"
								data-bs-target="#modifyReplyConfirmModal"
								data-reply-id="\${item.id}"
								id="\${modifyReplyButtonId}"
							>
							수정
							</button>
							<button 
								data-bs-toggle="modal" 
								data-bs-target="#removeReplyConfirmModal" 
								data-reply-id ="\${item.id}"
								id="\${removeReplyButtonId}"
							>
							삭제
							</button>
						</div>`;
						
					// `` 백틱
					const replyDiv =
						`<div>
							\${item.content} : \${item.inserted}
							\${item.writer}
							\${item.editable ? editButton : '' } <%-- ReplyDto editable true? false? 로  댓글 수정 삭제 버튼 불러오기  --%> 
						</div>`;  
						
					<!-- ReplyList 띄우기 -->	
					document.querySelector("#replyListContainer").insertAdjacentHTML("beforeend", replyDiv);
					
					//수정 폼 모달에 댓글내용 넣기
					document.querySelector("#"+ modifyReplyButtonId)
					.addEventListener("click", function(){
						document.querySelector("#modifyFormModalSubmitButton")
						.setAttribute("data-reply-id", this.dataset.replyId);
						readReplyAndSetModalForm(this.dataset.replyId);
					});	
					
					//삭제 확인 버튼에 replyId 옮기기
					document.querySelector("#"+ removeReplyButtonId)
					.addEventListener("click", function(){
						//console.log(this.dataset.replyId + "번 댓글을 삭제할 예정, 모달에 띄움")
						document.querySelector("#removeConfirmModalSubmitButton")
						.setAttribute("data-reply-id", this.dataset.replyId);
					});
				}//for문 중괄호닫기
			})//.then(list => {   중괄호,괄호 닫기	
		};//function listReply(){ 중괄호 닫기

			
		// 댓글 삭제 기능 만들기
	 	function removeReply(replyId){
			// /reply/remove/{id}, method:"delete"
			fetch(contextPath + "/reply/remove/" + replyId, {method:"delete"})
			.then(res => res.json())
			.then(data => {
				document.querySelector("#replyMessage").innerText = data.message })
			.then(() => listReply());
		}; 
		
		// 모달 확인버튼 -삭제
		document.querySelector("#removeConfirmModalSubmitButton").addEventListener("click", function() {
			removeReply(this.dataset.replyId);
		});

		
		
		//댓글쓰기 (if문으로 오류 수정)
		const replySendButton1 = document.querySelector("#replySendButton1");
		if(replySendButton1 != null) {
			
			replySendButton1.addEventListener("click", function(){
				
				
				const boardId = document.querySelector("#boardId").value;
				const content = document.querySelector("#replyInput1").value;
				
				const data = {boardId, content};
				
				fetch(`\${contextPath}/reply/add`, {method : "post", headers : {"Content-Type" : "application/json"}, body : JSON.stringify(data)})
				.then(res => res.json())
				.then(data =>{
					document.querySelector("#replyInput1").value = ""; //댓글input 초기화
					document.querySelector("#replyMessage").innerText = data.message;			
				})
				.then(() => listReply());
			});
		}
	</script>
</body>
</html>