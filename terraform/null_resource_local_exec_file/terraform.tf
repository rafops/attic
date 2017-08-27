resource "null_resource" "pwd" {
  provisioner "local-exec" {
    command = "basename $PWD > pwd.txt"
  }
}

data "template_file" "bucket_txt" {
  depends_on = ["null_resource.pwd"]
  template = "${file("pwd.txt")}"
}

output "bucket" {
  value = "${data.template_file.bucket_txt.rendered}"
}
