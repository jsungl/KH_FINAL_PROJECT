<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>


<style>
    .card-left{
        height: 150px;
        width: 200px;
        object-fit: cover;
    }
    /* .card-desc{
        text-overflow: ellipsis;
        overflow:hidden;
    } */
</style>


  <div class="container">

        <h3 class="mt-4">${localName} ${categoryName}</h3>
        <div class="row mt-3">

            <!-- 카테고리/지역 선택 -->
            <div class="col-sm-3 mx-2">
                <div class="p-3" style="border: 1px solid lightgray; border-radius: 5px;">
                    <h5>카테고리</h5>
                    <input type="radio" name="category" id="C0" value="C0" ${codeMap.categoryCode eq 'C0'? 'checked' : ''} />
                    <label for="C0">전체보기</label><br>
                    <c:forEach items="${categoryList}" var="category">
                     <input type="radio" name="category" id="${category.categoryCode}" value="${category.categoryCode}" ${codeMap.categoryCode eq category.categoryCode? 'checked' : ''}/>
                    <label for="${category.categoryCode}">${category.categoryName}</label><br>
                    </c:forEach>
                    <br>
    
                    <h5>지역</h5>
                    <input type="radio" name="location" id="L0" value="L0">
                    <label class="label-name" for="L0">전체보기</label><br>
                    <c:forEach items="${localList}" var ="local">
	                    <input type="radio" name="location" id="${local.localCode}" value="${local.localCode}" ${codeMap.localCode eq local.localCode? 'checked' : ''} >
	                    <label for="${local.localCode}">${local.localName}</label><br>
                    </c:forEach>
                </div>
               
            </div>

            <!-- 장소 리스트 -->
            <div class="col-sm-8 mx-2">

                <!-- 정렬 select -->
                <!-- <nav class="navbar navbar-light justify-content-between">
                    <a class="navbar-brand"></a> -->
                    <select name="sort" id="sort">
                        <option value="like-count" ${sort eq 'like-count' ? 'selected' : '' }>찜 많은 순</option>
                        <option value="board-count" ${sort eq 'board-count' ? 'selected' : '' }>게시글 많은 순</option>
                        <option value="place-name" ${sort eq 'place-name' ? 'selected' : '' }>이름순</option>
                    </select>
                  <!-- </nav> -->
                  
                  
                <%-- 리스트 --%>
                <c:if test="${placeList != null}">
                	 <c:forEach items="${placeList}" var="place">
	            	 <!-- 리스트 시작 -->
		               <div class="card mb-4" name="cardDiv">
		              	<a class="card-block stretched-link" style="color: black; text-decoration: none;" href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${place.placeNo}"> 
		                   <div class="row p-3">
		                       <div class="col-lg-4">
		                           <img class="img-fluid card-left" src="${pageContext.request.contextPath }/resources/upload/place/${place.renamedFilename}" alt="">
		                       </div>
		                       <div class="col-lg-8">
		                           <div class="card-body">
		                               <h5 class="card-title">
		                               <c:if test="${place.fromUser == 1}">
		                               	<span class="badge badge-warning">유저등록</span>
		                               </c:if>
		                               	${place.placeName}
		                               </h5>
		                               <p class="card-text">
		                                   <i class="fa fa-heart" aria-hidden="true"></i> ${place.placeLikeCount } &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> ${place.boardCount }
		                               </p>
		                               <p class="card-text card-desc">${place.content} </p>
		                           </div>
		                       </div>
		                   </div>
		                  </a>
		               </div>
		               <!-- 리스트 끝 -->
		            </c:forEach>
                </c:if>
	           
        

            </div>

        </div>


    </div>



<script>
/* $(".card-desc").ellipsify({
    count: 15 //숫자가 많을 수록 글자가 많이 노출되고 짤림
}); */

let categoryCode = "${codeMap.categoryCode}";
let localCode = "${codeMap.localCode}";

$("[name=category]").click((e) => {
	const sort = $("[name=sort]").val();
	categoryCode = $(e.target).val();
	//let categoryName = $(e.target).next().text();
	//location.href=`${pageContext.request.contextPath}/place/categoryList.do?categoryCode=\${categoryCode}&localCode=\${localCode}&sort=\{sort}`;
	refreshList(categoryCode, localCode, sort);
});

$("[name=location]").click((e) => {
	const sort = $("[name=sort]").val();
	localCode = $(e.target).val();
	//let localName = $(e.target).next().text();
	//location.href=`${pageContext.request.contextPath}/place/categoryList.do?categoryCode=\${categoryCode}&localCode=\${localCode}&sort=\{sort}`;
	refreshList(categoryCode, localCode, sort);
	
});


//리스트 정렬 변경
$("[name=sort]").change((e) => {
	const sort = $(e.target).val();
	refreshList(categoryCode, localCode, sort);

});

function refreshList(categoryCode, localCode, sort){
	location.href=`${pageContext.request.contextPath}/place/categoryList.do?categoryCode=\${categoryCode}&localCode=\${localCode}&sort=\${sort}`;
}
  
</script>


<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>