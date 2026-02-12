import { FetchClient } from "../utils/fetchClient";

interface ZoneResponse {
    id: string;
    name: string;
    description: string;
    capacity: number;
    type: string;
    isActive: boolean;
}

interface SpaceResponse {
    id: string;
    code: string;
    status: string;
    isReserved: boolean;
    zoneId: string;
    zoneName: string;
    priority: number;
}

export class ZoneService {
    private readonly baseUrl: string;

    constructor() {
        this.baseUrl = process.env.ZONE_SERVICE_URL || "http://localhost:8080/api";
        if (!this.baseUrl) {
            throw new Error("No se pudo establecer la conexión con el servicio de zonas");
        }
    };

    getAllZones = async (): Promise<ZoneResponse[]> => {
        const url = `${this.baseUrl}/zones`;
        return await FetchClient.get<ZoneResponse[]>(url);
    };

    getAvailableSpacesByZone = async (zoneId: string): Promise<SpaceResponse[]> => {
        const url = `${this.baseUrl}/spaces/availablesbyzone/${zoneId}`; //falta este endpoint
        return await FetchClient.get<SpaceResponse[]>(url);
    };
}
