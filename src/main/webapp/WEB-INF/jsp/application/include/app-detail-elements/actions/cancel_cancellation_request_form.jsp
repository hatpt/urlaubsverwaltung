<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:if test="${action == 'cancel-cancellation-request'}">
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            $("#cancel-cancellation-request").show();
        })
    </script>
</c:if>

<spring:url var="URL_PREFIX" value="/web"/>

<form:form id="cancel-cancellation-request" cssClass="form action-form confirm alert alert-danger" method="POST"
           action="${URL_PREFIX}/application/${application.id}/cancel-cancellation-request" modelAttribute="comment">

    <div class="form-group">
        <strong class="tw-font-medium">
            <!-- TODO -->
            Anfrage auf Stornierung wirklich ablehnen?
        </strong>
    </div>

    <div class="form-group">
        <div class="tw-text-sm">
            <c:choose>
                <%-- comment is obligat if it's not the own application or if the application is in status allowed --%>
                <c:when test="${application.status == 'ALLOWED_CANCELLATION_REQUESTED'}">
                    <spring:message code="action.comment.mandatory"/>
                </c:when>
                <c:otherwise>
                    <spring:message code="action.comment.optional"/>
                </c:otherwise>
            </c:choose>
            : (<span id="text-cancel-cancellation-request"></span><spring:message code="action.comment.maxChars"/>)
        </div>
        <form:textarea rows="2" path="text" cssClass="form-control" cssErrorClass="form-control error"
                       onkeyup="count(this.value, 'text-cancel-cancellation-request');"
                       onkeydown="maxChars(this,200); count(this.value, 'text-cancel-cancellation-request');"/>
    </div>

    <div class="form-group is-sticky row">
        <button type="submit" class="btn btn-danger col-xs-12 col-sm-5">
            <!-- TODO -->
            Stornierung ablehnen
        </button>
        <button type="button" class="btn btn-default col-xs-12 col-sm-5 pull-right" onclick="$('#cancel-cancellation-request').hide();">
            <!-- TODO -->
            <spring:message code="action.cancel"/>
        </button>
    </div>

</form:form>
