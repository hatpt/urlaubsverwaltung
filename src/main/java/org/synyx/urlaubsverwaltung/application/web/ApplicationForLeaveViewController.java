package org.synyx.urlaubsverwaltung.application.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.synyx.urlaubsverwaltung.application.domain.Application;
import org.synyx.urlaubsverwaltung.application.service.ApplicationService;
import org.synyx.urlaubsverwaltung.department.DepartmentService;
import org.synyx.urlaubsverwaltung.person.Person;
import org.synyx.urlaubsverwaltung.person.PersonService;
import org.synyx.urlaubsverwaltung.workingtime.WorkDaysCountService;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;

import static java.util.stream.Collectors.toList;
import static org.synyx.urlaubsverwaltung.application.domain.ApplicationStatus.ALLOWED_CANCELLATION_REQUESTED;
import static org.synyx.urlaubsverwaltung.application.domain.ApplicationStatus.TEMPORARY_ALLOWED;
import static org.synyx.urlaubsverwaltung.application.domain.ApplicationStatus.WAITING;
import static org.synyx.urlaubsverwaltung.person.Role.BOSS;
import static org.synyx.urlaubsverwaltung.person.Role.DEPARTMENT_HEAD;
import static org.synyx.urlaubsverwaltung.person.Role.OFFICE;
import static org.synyx.urlaubsverwaltung.person.Role.SECOND_STAGE_AUTHORITY;
import static org.synyx.urlaubsverwaltung.person.Role.USER;

/**
 * Controller for showing applications for leave in a certain state.
 */
@Controller
@RequestMapping("/web")
public class ApplicationForLeaveViewController {

    private final ApplicationService applicationService;
    private final WorkDaysCountService calendarService;
    private final DepartmentService departmentService;
    private final PersonService personService;

    @Autowired
    public ApplicationForLeaveViewController(ApplicationService applicationService, WorkDaysCountService calendarService,
                                             DepartmentService departmentService, PersonService personService) {
        this.applicationService = applicationService;
        this.calendarService = calendarService;
        this.departmentService = departmentService;
        this.personService = personService;
    }

    /*
     * Show waiting applications for leave.
     */
    @GetMapping("/application")
    public String showWaiting(Model model) {

        final Person signedInUser = personService.getSignedInUser();
        model.addAttribute("signedInUser", signedInUser);

        final List<ApplicationForLeave> applicationsForLeave = getAllRelevantApplicationsForLeave(signedInUser);
        model.addAttribute("applications", applicationsForLeave);

        final List<ApplicationForLeave> applicationsForLeaveCancellationRequests = getAllRelevantApplicationsForLeaveCancellationRequests();
        model.addAttribute("applications_cancellation_request", applicationsForLeaveCancellationRequests);

        return "application/app_list";
    }

    private List<ApplicationForLeave> getAllRelevantApplicationsForLeaveCancellationRequests() {

        final Person user = personService.getSignedInUser();
        if (user.hasRole(OFFICE)) {
            return applicationService.getForStates(List.of(ALLOWED_CANCELLATION_REQUESTED)).stream()
                .map(application -> new ApplicationForLeave(application, calendarService))
                .sorted(byStartDate())
                .collect(toList());
        }

        return List.of();
    }

    private List<ApplicationForLeave> getAllRelevantApplicationsForLeave(Person signedInUser) {

        if (signedInUser.hasRole(BOSS) || signedInUser.hasRole(OFFICE)) {
            // Boss and Office can see all waiting and temporary allowed applications leave
            return getApplicationsForLeaveForBossOrOffice();
        }

        final List<ApplicationForLeave> applicationsForLeave = new ArrayList<>();

        if (signedInUser.hasRole(SECOND_STAGE_AUTHORITY)) {
            // Department head can see waiting and temporary allowed applications for leave of certain department(s)
            applicationsForLeave.addAll(getApplicationsForLeaveForSecondStageAuthority(signedInUser));
        }

        if (signedInUser.hasRole(DEPARTMENT_HEAD)) {
            // Department head can see only waiting applications for leave of certain department(s)
            applicationsForLeave.addAll(getApplicationsForLeaveForDepartmentHead(signedInUser));
        }

        if (signedInUser.hasRole(USER)) {
            // Department head can see only waiting applications for leave of certain department(s)
            applicationsForLeave.addAll(getApplicationsForLeaveForUser(signedInUser));
        }

        return applicationsForLeave.stream()
            .filter(distinctByKey(ApplicationForLeave::getId))
            .collect(toList());
    }

    private List<ApplicationForLeave> getApplicationsForLeaveForBossOrOffice() {
        return applicationService.getForStates(List.of(WAITING, TEMPORARY_ALLOWED)).stream()
            .map(application -> new ApplicationForLeave(application, calendarService))
            .sorted(byStartDate())
            .collect(toList());
    }

    private List<ApplicationForLeave> getApplicationsForLeaveForUser(Person user) {
        return applicationService.getForStatesAndPerson(List.of(WAITING, TEMPORARY_ALLOWED), List.of(user)).stream()
            .map(application -> new ApplicationForLeave(application, calendarService))
            .sorted(byStartDate())
            .collect(toList());
    }

    private List<ApplicationForLeave> getApplicationsForLeaveForDepartmentHead(Person head) {
        final List<Person> members = departmentService.getManagedMembersOfDepartmentHead(head);
        return applicationService.getForStatesAndPerson(List.of(WAITING), members).stream()
            .filter(withoutApplicationsOf(head))
            .filter(withoutSecondStageAuthorityApplications())
            .map(application -> new ApplicationForLeave(application, calendarService))
            .sorted(byStartDate())
            .collect(toList());
    }

    private List<ApplicationForLeave> getApplicationsForLeaveForSecondStageAuthority(Person secondStage) {
        final List<Person> members = departmentService.getManagedMembersForSecondStageAuthority(secondStage);
        return applicationService.getForStatesAndPerson(List.of(WAITING, TEMPORARY_ALLOWED), members).stream()
            .filter(withoutApplicationsOf(secondStage))
            .map(application -> new ApplicationForLeave(application, calendarService))
            .sorted(byStartDate())
            .collect(toList());
    }

    private Predicate<Application> withoutApplicationsOf(Person head) {
        return application -> !application.getPerson().equals(head);
    }

    private Predicate<Application> withoutSecondStageAuthorityApplications() {
        return application -> !application.getPerson().getPermissions().contains(SECOND_STAGE_AUTHORITY);
    }

    private Comparator<ApplicationForLeave> byStartDate() {
        return Comparator.comparing(Application::getStartDate);
    }

    private static <T> Predicate<T> distinctByKey(Function<? super T, ?> keyExtractor) {
        final Map<Object, Boolean> seen = new ConcurrentHashMap<>();
        return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
    }
}
