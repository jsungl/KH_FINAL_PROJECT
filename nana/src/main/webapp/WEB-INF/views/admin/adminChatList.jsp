<%@page import="com.kh.nana.place.model.vo.PlaceExt"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>

<div class="container">
<div class="row mt-2">
	<div class="col-3 mr-3">
		<div class="row"><p class="mx-auto mb-1 font-weight-bold">채팅 유저 리스트</p></div>
		<div class="row list-group">
			<c:forEach items="${chatIdList}" var="id">
			  <a href="#" class="chatId list-group-item list-group-item-action">${id}</a>
			</c:forEach>
		</div>
	</div>
	<div class="col">
		<div class="row"><p class="mx-auto mb-1 font-weight-bold">채팅 내역</p></div>
		<div class="row border p-2" id="chatList" style=" height: 1000px; overflow:auto;">
			<!--  아이디를 선택하면 채팅 내역이 보입니다. -->
		<div class="container-fluid">
		<table class="table table-striped" id="chatListTable" style="display:none;">
		  <thead>
		    <tr>
		      <th scope="col">#</th>
		      <th scope="col">발신일</th>
		      <th scope="col">송신자</th>
		      <th scope="col">내용</th>
		    </tr>
		  </thead>
		  <tbody id="tbody">
		  <!--  행 시작 -->
		   <%-- <tr>
		      <td>${chat.chatNo}</td>
		      <td>${chat.regTime}</td>
		      <td>${chat.formId}</td>
		      <td>${chat.message}</td>
		    </tr> --%>
		  <!--  행 끝 -->
		  </tbody>
		</table>
		</div>	
		
		</div>
	</div>

</div>
</div>

<script>
$(".chatId").click((e) => {
	const id = $(e.target).text();
	console.log(id);

 	$.ajax({
		url:'${pageContext.request.contextPath}/admin/adminChatListById.do',
		data: {id},
		success(data){
			console.log(data);
			
			let $tbody = $("#tbody");
			$tbody.empty();

			let html = "";

			for(var i = 0; i < data.length; i++){
				let chat = data[i];
				const date = new Date(chat.regTime);
				const dateFormat = date.customFormat("#YYYY#/#MM#/#DD# #hhhh#:#mm#:#ss#");
				console.log("dateFormat", dateFormat);
				html += `<tr>
					      <td>\${chat.chatNo}</td>
					      <td>\${dateFormat}</td>
					      <td>\${chat.fromId}</td>
					      <td>\${chat.message}</td>
					    </tr>`;
			}

			$tbody.html(html);
			
			$("#chatListTable").show();
			
		},
		error: console.log,
		complete: function(){
		}

	}); 

});

</script>


<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>