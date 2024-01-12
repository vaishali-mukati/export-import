
enum Status { SUCCESS, ERROR }

class Resource {
  final Status status;
  final data;
  final String? message;

  Resource(this.status, this.data, this.message);

  static Resource success(var data) {
    return new Resource(Status.SUCCESS, data, null);
  }

  static Resource error(String msg, var data) {
    return new Resource(Status.ERROR, data, msg);
  }
}