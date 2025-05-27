output "build_server_public_ip" {
  value = aws_instance.build_server.public_ip
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}
