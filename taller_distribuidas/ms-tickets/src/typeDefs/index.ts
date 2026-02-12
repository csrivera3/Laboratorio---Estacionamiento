const typeDefs = `
  type Ticket {
    id: String!
    codigoTicket: String!
    personaIdentificacion: String!
    personaNombres: String!
    vehiculoPlaca: String!
    vehiculoMarca: String!
    vehiculoModelo: String!
    zonaNombre: String!
    espacioCodigo: String!
    fechaIngreso: String!
    fechaSalida: String
    estado: String!
    tiempoEstacionado: Int!
    createdAt: String!
    updatedAt: String!
  }

  type Query {
    obtenerTickets: [Ticket]
    obtenerTicket(id: String!): Ticket
  }

  type Mutation {
    crearTicket(
      codigoTicket: String!
      personaIdentificacion: String!
      personaNombres: String!
      vehiculoPlaca: String!
      vehiculoMarca: String!
      vehiculoModelo: String!
      zonaNombre: String!
      espacioCodigo: String!
      fechaIngreso: String!
      tiempoEstacionado: Int!
    ): Ticket
    actualizarTicket(id: String!, estado: String!): Ticket
    eliminarTicket(id: String!): Boolean
  }
`;

export default typeDefs;
