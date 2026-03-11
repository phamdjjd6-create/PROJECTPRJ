package controller;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import service.PersonnelService;

@Path("/personnel")
@Produces(MediaType.APPLICATION_JSON)
public class PersonnelResource {

    private final PersonnelService personnelService = new PersonnelService();

    @GET
    @Path("/employees")
    public Response getEmployees() {
        return Response.ok(personnelService.findAllEmployees()).build();
    }

    @GET
    @Path("/customers")
    public Response getCustomers() {
        return Response.ok(personnelService.findAllCustomers()).build();
    }
}
