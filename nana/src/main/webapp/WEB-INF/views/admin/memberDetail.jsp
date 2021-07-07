<%@page import="java.util.*"%>
<%@page import="com.kh.nana.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<% 

	Member member = (Member) request.getAttribute("member");
	//System.out.println(member);
	
	
	if(member != null){
		String[] preference = member.getPreference();
		List<String> perferenceList = (preference != null) ? Arrays.asList(preference) : null;
		pageContext.setAttribute("perferenceList", perferenceList);		
	}
	
	
	
%>
<style>
div#member-container {
	border:1px solid lightgray;
	border-radius: 10px;
	padding:15px;
}

div#memberActivityList a.active{
    background-color: #f6bd3a;
    border-color: #d39e34;
}


</style>



<div class="container">

<div class="mx-auto mt-5 text-center" id="member-container" style="width:50%;">

		<form>
		
			<div class="form-group row">
			  <label for="memberId" class="col-sm-2 col-form-label">아이디</label>
			  <div class="col-sm-10">
			    <input type="text" class="form-control" id="memberId" name="memberId" value="${member.id}" readonly/>
			  </div>
			</div>
			
			
			<div class="form-group row">
			  <label for="memberName" class="col-sm-2 col-form-label">이름</label>
			  <div class="col-sm-10">
			    <input type="text" class="form-control" id="memberName" name="memberName" value="${member.name}" readonly/>
			  </div>
			</div>
		
			<div class="form-group row">
			  <label for="birthday" class="col-sm-2 col-form-label">생일</label>
			  <div class="col-sm-10">
			    <input type="date" class="form-control" name="birthday" id="birthday" value="${member.birthday}" readonly/>
			  </div>
			</div>
		
			<div class="form-group row">
			  <label for="email" class="col-sm-2 col-form-label">E-mail</label>
			  <div class="col-sm-10">
			    <input type="email" class="form-control" name="email" id="email" value="${member.email}" readonly/>
			  </div>
			</div>
			
			<div class="form-group row">
			  <label for="phone" class="col-sm-2 col-form-label">Mobile</label>
			  <div class="col-sm-10">
			    <input type="tel" class="form-control" name="phone" id="phone" maxlength="11" value="${member.phone}" readonly/>
			  </div>
			</div>
			
			
			<div class="form-group row">
	    		<label class="col-sm-2 col-form-label">성별</label>
		    	<div class="col-sm-10 mt-1">
				    <div class="form-check form-check-inline">
					  <input class="form-check-input" type="radio" name="gender"
					  		 id="gender0" value="M" ${member.gender eq 'M' ? 'checked' : '' } onclick="return(false);">
					  <label class="form-check-label" for="gender0">남</label>
					</div>
					<div class="form-check form-check-inline">
					  <input class="form-check-input" type="radio" name="gender" 
					  		 id="gender1" value="F" ${member.gender eq 'F' ? 'checked' : '' } onclick="return(false);">
					  <label class="form-check-label" for="gender1">여</label>
					</div>
				</div>
			</div>
			
			
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">취향</label>
				<div class="col-sm-10 mt-2">
					<div class="form-check form-check-inline">
					  <label for="preference0" class="form-check-label" >랜드마크</label>
					  <input type="checkbox" class="form-check-input" name="preference" id="preference0" value="랜드마크" ${perferenceList.contains('랜드마크') ? 'checked' : ''} disabled>
					</div>
					<div class="form-check form-check-inline">
					  <label for="preference1" class="form-check-label" >레저/스포츠</label>
					  <input type="checkbox" class="form-check-input" name="preference" id="preference1" value="레저스포츠" ${perferenceList.contains('레저스포츠') ? 'checked' : ''} disabled>
					</div>
					<div class="form-check form-check-inline">
					  <label for="preference2" class="form-check-label" >오락</label>
					  <input type="checkbox" class="form-check-input" name="preference" id="preference2" value="오락" ${perferenceList.contains('오락') ? 'checked' : ''} disabled>
					</div>
					<div class="form-check form-check-inline">
					  <label for="preference3" class="form-check-label" >맛집</label>
					  <input type="checkbox" class="form-check-input" name="preference" id="preference3" value="맛집" ${perferenceList.contains('맛집') ? 'checked' : ''} disabled>
					</div>
					<div class="form-check form-check-inline">
					  <label for="preference4" class="form-check-label" >캠핑/차박</label>
					  <input type="checkbox" class="form-check-input" name="preference" id="preference4" value="캠핑" ${perferenceList.contains('캠핑') ? 'checked' : ''} disabled>
					</div>
				</div>
			</div>
			
			
			
			<div class="form-group row">
	    		<label class="col-sm-2 col-form-label">SNS계정</label>
	    		<div class="col-sm-10 mt-2">
	    			<c:choose>
		    			<c:when test="${member.sso eq 'naver'}">
			    			<p>NAVER</p>		    			
		    			</c:when>
	    				<c:when test="${member.sso eq 'google'}">
			    			<p>GOOGLE</p>		    			
		    			</c:when>
		    			<c:when test="${member.sso eq 'kakao'}">
			    			<p>KAKAO</p>		    			
		    			</c:when>
		    			<c:otherwise>
		    				<p>없음</p>
		    			</c:otherwise>
	    			</c:choose>
	    		</div>
	    	</div>
		
		
		</form>

</div>

<div class="mx-auto mt-5 text-center" id="memberActivityList" style="width:60%;">
	<div class="row">
        <div class="col-4">
          <div class="list-group" id="list-tab" role="tablist">
            <a class="list-group-item list-group-item-action active" id="list-home-list" data-toggle="list" href="#list-home" role="tab" aria-controls="home">
              게시글
	            <c:if test="${not empty boardListById}">
	            	<span class="badge badge-primary badge-pill" style="background-color: #256d69;">
	            		${fn:length(boardListById)}
	            	</span>
	            </c:if>
            </a>
            <a class="list-group-item list-group-item-action" id="list-profile-list" data-toggle="list" href="#list-profile" role="tab" aria-controls="profile">
            댓글
	            <c:if test="${not empty boardCommentList}">
	            	<span class="badge badge-primary badge-pill" style="background-color: #256d69;">
	              		${fn:length(boardCommentList)}
	            	</span>
	            </c:if>
            </a>
            <a class="list-group-item list-group-item-action" id="list-messages-list" data-toggle="list" href="#list-messages" role="tab" aria-controls="messages">
            찜목록
	            <c:if test="${not empty likePlaceList}">
	            	<span class="badge badge-primary badge-pill" style="background-color: #256d69;">
	              		${fn:length(likePlaceList)}
	            	</span>
	            </c:if>
            </a>
            <a class="list-group-item list-group-item-action" id="list-settings-list" data-toggle="list" href="#list-settings" role="tab" aria-controls="settings">
            좋아요목록
	           	<c:if test="${not empty likeBoardList}">
	            	<span class="badge badge-primary badge-pill" style="background-color: #256d69;">
	              		${fn:length(likeBoardList)}
	            	</span>
	            </c:if>
            </a>
          </div>
        </div>
        
        <div class="col-8" style="padding:10px;border:1px solid lightgray;border-radius: 10px;">
          <div class="tab-content" id="nav-tabContent">
            <div class="tab-pane fade show active" id="list-home" role="tabpanel" aria-labelledby="list-home-list">
            	<c:if test="${not empty boardListById}">
	            	<c:forEach items="${boardListById}" var="board" varStatus="status">
	            		<p>
	            			${status.count}.
	            			<a href="${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${board.boardNo}" style="color:black;">${board.title}</a>
	            		</p>
	            	</c:forEach>            	
            	</c:if>
            </div>
            <div class="tab-pane fade" id="list-profile" role="tabpanel" aria-labelledby="list-profile-list">
            	<c:if test="${not empty boardCommentList}">
	            	<c:forEach items="${boardCommentList}" var="comment" varStatus="status">
	            		<p>
	            			${status.count}.
	            			${comment.content} | <fmt:formatDate value="${comment.regDate}" pattern="yy/MM/dd"/>
	            		</p>
	            	</c:forEach>            	
            	</c:if>     
            </div>
            <div class="tab-pane fade" id="list-messages" role="tabpanel" aria-labelledby="list-messages-list">
            	<c:if test="${not empty likePlaceList}">
	            	<c:forEach items="${likePlaceList}" var="likePlace" varStatus="status">
	            		<p>
	            			${status.count}.
	            			<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${likePlace.placeNo}" style="color:black;">${likePlace.placeName} | ${likePlace.address}</a>
	            		</p>
	            	</c:forEach>            	
            	</c:if>
            </div>
            <div class="tab-pane fade" id="list-settings" role="tabpanel" aria-labelledby="list-settings-list">
            	<c:if test="${not empty likeBoardList}">
	            	<c:forEach items="${likeBoardList}" var="likeBoard" varStatus="status">
	            		<p>
	            			${status.count}.
	            			<a href="${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${likeBoard.boardNo}" style="color:black;">${likeBoard.title}</a>
	            		</p>
	            	</c:forEach>            	
            	</c:if>
            </div>
          </div>
        </div>
      
    </div>


</div>

</div>













<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>