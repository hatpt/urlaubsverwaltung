package org.synyx.urlaubsverwaltung.sicknote.web;

import org.springframework.beans.BeanUtils;
import org.synyx.urlaubsverwaltung.period.WeekDay;
import org.synyx.urlaubsverwaltung.sicknote.SickNote;
import org.synyx.urlaubsverwaltung.workingtime.WorkDaysCountService;

import java.math.BigDecimal;

/**
 * Represents an extended {@link org.synyx.urlaubsverwaltung.sicknote.SickNote} with information about the number
 * of work days. (depending on working time of the person)
 */
public class ExtendedSickNote extends SickNote {

    private final BigDecimal workDays;

    public ExtendedSickNote(SickNote sickNote, WorkDaysCountService calendarService) {

        // copy all the properties from the given sick note
        BeanUtils.copyProperties(sickNote, this);

        // not copied, must be set explicitly
        setId(sickNote.getId());

        // calculate the work days
        this.workDays = calendarService.getWorkDaysCount(getDayLength(), getStartDate(), getEndDate(), getPerson());
    }

    public BigDecimal getWorkDays() {
        return workDays;
    }

    public WeekDay getWeekDayOfStartDate() {
        return WeekDay.getByDayOfWeek(getStartDate().getDayOfWeek().getValue());
    }

    public WeekDay getWeekDayOfEndDate() {
        return WeekDay.getByDayOfWeek(getEndDate().getDayOfWeek().getValue());
    }
}
