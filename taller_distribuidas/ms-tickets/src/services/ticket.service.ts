import { Ticket } from "../entities/Ticket.entity";
import { AppDataSource } from "../utils/database";
import { PersonaService } from "./persona.service";
import { ZoneService } from "./zone.service";

export class TicketService {
    private readonly ticketRepository = AppDataSource.getRepository(Ticket);
    private readonly zoneService = new ZoneService();
    private readonly personaService = new PersonaService();

    private readonly generateTicketCode = () => {
        return 'TICKET-' + Math.random().toString(36).substr(2, 9).toUpperCase();
    }
}