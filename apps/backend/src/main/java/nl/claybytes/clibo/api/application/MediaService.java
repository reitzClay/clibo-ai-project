// @Path("/api/v1/media")
// @Produces(MediaType.APPLICATION_JSON)
// @Consumes(MediaType.MULTIPART_FORM_DATA)
// public class MediaResource {

//     @Inject
//     MediaService mediaService; // Application layer orchestrator

//     @POST
//     @Path("/upload")
//     public Response registerMedia(@MultipartForm MediaUploadDTO upload) {
//         // 1. Process the local file path/upload
//         // 2. Delegate to MediaService to link with a VisionItem
//         var asset = mediaService.processNewMedia(upload);
//         return Response.status(Response.Status.CREATED).entity(asset).build();
//     }
// }
