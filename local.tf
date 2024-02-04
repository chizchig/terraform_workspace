locals{
    generate_subnet_cidr_blocks = [
        for index in range(2) : cidrsubnet("10.0.0.0/16", 8, index)
    ]
}
