package org.synyx.urlaubsverwaltung.restapi.department;

import org.junit.Before;
import org.junit.Test;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.synyx.urlaubsverwaltung.core.department.DepartmentService;
import org.synyx.urlaubsverwaltung.restapi.ApiExceptionHandlerControllerAdvice;

import java.util.Collections;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


/**
 * @author  Aljona Murygina - murygina@synyx.de
 */
public class DepartmentControllerTest {

    private MockMvc mockMvc;

    private DepartmentService departmentServiceMock;

    @Before
    public void setUp() {

        departmentServiceMock = mock(DepartmentService.class);

        mockMvc = MockMvcBuilders.standaloneSetup(new DepartmentController(departmentServiceMock))
            .setControllerAdvice(new ApiExceptionHandlerControllerAdvice())
                .build();
    }


    @Test
    public void ensureReturnsAllDepartments() throws Exception {

        when(departmentServiceMock.getAllDepartments()).thenReturn(Collections.emptyList());

        mockMvc.perform(get("/api/departments")).andExpect(status().isOk());

        verify(departmentServiceMock).getAllDepartments();
    }
}
