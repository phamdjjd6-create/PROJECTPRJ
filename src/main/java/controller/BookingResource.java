package controller;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import model.TblBookings;
import service.BookingService;

@Path("/bookings")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BookingResource {

    private final BookingService bookingService = new BookingService();

    @GET
    public Response getAll() {
        return Response.ok(bookingService.findAll()).build();
    }

    @POST
    public Response create(TblBookings booking) {
        try {
            TblBookings created = bookingService.makeReservation(booking);
            return Response.status(Response.Status.CREATED).entity(created).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST).entity(e.getMessage()).build();
        }
    }

    @POST
    @Path("/{id}/checkin")
    public Response checkIn(@PathParam("id") String id) {
        bookingService.checkIn(id);
        return Response.ok().build();
    }
}
