package controller;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.Date;
import java.util.List;
import model.TblFacilities;
import service.FacilityService;

@Path("/facilities")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class FacilityResource {

    private final FacilityService facilityService = new FacilityService();

    @GET
    public List<TblFacilities> getAll() {
        return facilityService.findAll();
    }

    @GET
    @Path("/{id}")
    public TblFacilities getById(@PathParam("id") String id) {
        return facilityService.findById(id);
    }

    @GET
    @Path("/search")
    public List<TblFacilities> search(
            @QueryParam("start") long startMs,
            @QueryParam("end") long endMs,
            @QueryParam("type") String type) {
        return facilityService.findAvailable(new Date(startMs), new Date(endMs), type);
    }

    @PUT
    @Path("/{id}/status")
    public Response updateStatus(@PathParam("id") String id, @QueryParam("value") String status) {
        facilityService.updateStatus(id, status);
        return Response.ok().build();
    }
}
