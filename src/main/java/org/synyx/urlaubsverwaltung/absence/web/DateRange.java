package org.synyx.urlaubsverwaltung.absence.web;

import java.time.LocalDate;
import java.util.Iterator;
import java.util.NoSuchElementException;

final class DateRange implements Iterable<LocalDate> {

    private final LocalDate startDate;
    private final LocalDate endDate;

    DateRange(LocalDate startDate, LocalDate endDate) {
        this.startDate = startDate;
        this.endDate = endDate;
    }

    LocalDate getStartDate() {
        return startDate;
    }

    LocalDate getEndDate() {
        return endDate;
    }

    @Override
    public Iterator<LocalDate> iterator() {
        return new DateRangeIterator(startDate, endDate);
    }

    private static final class DateRangeIterator implements Iterator<LocalDate> {


        private LocalDate cursor;
        private final LocalDate endDate;

        DateRangeIterator(LocalDate startDate, LocalDate endDate) {
            this.cursor = startDate;
            this.endDate = endDate;
        }

        @Override
        public boolean hasNext() {
            return cursor.isBefore(endDate) || cursor.isEqual(endDate);
        }

        @Override
        public LocalDate next() {

            if (cursor.isAfter(endDate)) {
                throw new NoSuchElementException("next date is after endDate which is not in range anymore.");
            }

            final LocalDate current = cursor;

            cursor = cursor.plusDays(1);

            return current;
        }
    }
}
