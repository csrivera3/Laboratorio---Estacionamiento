import { Ticket } from '../entities/Ticket.entity';
import { AppDataSource } from '../index';

const resolvers = {
  Query: {
    obtenerTickets: async () => {
      const ticketRepo = AppDataSource.getRepository(Ticket);
      return await ticketRepo.find();
    },
    obtenerTicket: async (_: any, { id }: any) => {
      const ticketRepo = AppDataSource.getRepository(Ticket);
      return await ticketRepo.findOneBy({ id });
    },
  },
  Mutation: {
    crearTicket: async (_: any, { 
      codigoTicket, 
      personaIdentificacion, 
      personaNombres, 
      vehiculoPlaca,
      vehiculoMarca,
      vehiculoModelo,
      zonaNombre,
      espacioCodigo,
      fechaIngreso,
      tiempoEstacionado
    }: any) => {
      const ticketRepo = AppDataSource.getRepository(Ticket);
      const ticket = ticketRepo.create({
        codigoTicket,
        personaIdentificacion,
        personaNombres,
        vehiculoPlaca,
        vehiculoMarca,
        vehiculoModelo,
        zonaNombre,
        espacioCodigo,
        fechaIngreso,
        tiempoEstacionado,
        estado: 'ACTIVO',
      });
      return await ticketRepo.save(ticket);
    },
    actualizarTicket: async (_: any, { id, estado }: any) => {
      const ticketRepo = AppDataSource.getRepository(Ticket);
      await ticketRepo.update(id, { estado });
      return await ticketRepo.findOneBy({ id });
    },
    eliminarTicket: async (_: any, { id }: any) => {
      const ticketRepo = AppDataSource.getRepository(Ticket);
      const result = await ticketRepo.delete(id);
      return (result.affected || 0) > 0;
    },
  },
};

export default resolvers;
