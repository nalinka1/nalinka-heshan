// Viewer-request function for the default cache behavior in cloudfront.tf.
//
// The S3 origin is private and reached through OAC, not S3's static website
// hosting endpoint (see s3.tf) — so there is no automatic /path/ ->
// /path/index.html resolution the way a webserver or S3 website hosting would
// give us. default_root_object only covers the bare "/" request. Without this
// function, a request for "/architecture" looks for an S3 object literally
// named "architecture", finds nothing, and the custom_error_response 403->200
// fallback in cloudfront.tf silently serves index.html (the homepage) with a
// 200 instead of the intended page.
function handler(event) {
	var request = event.request;
	var uri = request.uri;

	if (uri.endsWith('/')) {
		request.uri = uri + 'index.html';
		return request;
	}

	var lastSegment = uri.substring(uri.lastIndexOf('/') + 1);
	if (lastSegment.indexOf('.') === -1) {
		request.uri = uri + '/index.html';
	}

	return request;
}
