<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	#searchTypeSelect{
		width: auto;
	}
</style>

<%-- authorize tag --%>
<%-- spring security expressions  p673,674--%>
<sec:authorize access="isAuthenticated()" var="loggedIn"/>
<c:if test="${ loggedIn}">
	<h1>로그인 됨</h1>
</c:if>
<c:if test="${not loggedIn}">
	<h1>로그인 안됨 !</h1>
</c:if>
	
<%--
<sec:authorize access="${not loggedIn }">
	<h1>로그인 안됨!</h1>
</sec:authorize>
 --%>
<c:url value="/board/list" var="listLink"/>	
<c:url value="/board/register" var="registerLink"/>
<c:url value="/member/signup" var="signupLink"/>
<c:url value="/member/list" var="memberListLink"/>
<c:url value="/member/login" var="loginLink"/>
<c:url value="/member/logout" var="logoutLink"/>	

<nav class="navbar navbar-expand-md bg-light mb-3">
  <div class="container-md">
    <a class="navbar-brand" href="${listLink }">게시판</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
      
        <li class="nav-item">
         	 <a class="nav-link ${active eq 'list' ? 'active':'' } "  href="${listLink }">목록</a>
        </li>
        
        <c:if test="${loggedIn }">
	        <li class="nav-item">
	          	<a class="nav-link ${active eq 'register' ? 'active':'' }" href="${registerLink}">작성</a>
	        </li>
	        <li class="nav-item">
          	<a class="nav-link ${active eq 'memberList' ? 'active':'' }" href="${memberListLink}">회원목록</a>
        </li>
         </c:if>
        <c:if test="${not loggedIn }"> 
	        <li class="nav-item">
	          	<a class="nav-link ${active eq 'signup' ? 'active':'' }" href="${signupLink}">회원가입</a>
	        </li>
        </c:if>
        <c:if test="${not loggedIn }">
	        <li class="nav-item">
	          	<a class="nav-link ${active eq 'memberList' ? 'active':'' }" href="${loginLink}">로그인</a>
	        </li>
        </c:if>
        <c:if test="${loggedIn }">
	        <li class="nav-item">
	          	<a class="nav-link ${active eq 'memberList' ? 'active':'' }" href="${logoutLink}">로그아웃</a>
	        </li>
        </c:if>
      </ul>
    
      <form action="${listLink }" class="d-flex" role="search">
      	
      		<select name="t" id="searchTypeSelect" class="form-select">
      			<option value="all" >전체</option>
      			<option value="title" ${param.t eq 'title' ? 'selected' : ''}>제목</option>
      			<option value="content" ${param.t eq 'content' ? 'selected' : ''}>본문</option>
      			<option value="writer" ${param.t eq 'writer' ? 'selected' : ''}>작성자</option>
      		</select>
      	
        	<input class="form-control me-2" type="search" name="q" value="${param.q }" placeholder="Search" aria-label="Search">
        	
        	<button class="btn btn-outline-success" type="submit">
       		 	<i class="fa-solid fa-magnifying-glass"></i>
       		</button>
      </form>
      
    </div>
  </div>
</nav>