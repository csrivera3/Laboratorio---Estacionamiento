import { FetchClient } from "../utils/fetchClient";

interface PersonaResponse {
    id: string;
    identificacion: string;
    nombre: string; //nombres completos - razon social
    email: string;
    telefono: string;
    tipoPersona: string; //ENUM: NATURAL o JURIDICA
    activo: boolean;
}

interface VehiculoResponse {
    id: string;
    placa: string;
    marca: string;
    modelo: string;
    color: string;
    anioFabricacion: number;
    tipoVehiculo: string; //ENUM: CARRO, MOTO, CAMIONETA, CAMION, OTRO
    propietarioId: string;
    nombrePropietario: string;
    fechaRegistro: string;
    impuesto: boolean;
    activo: boolean;
}

export class PersonaService {
    private readonly baseUrl: string;

    constructor() {
        this.baseUrl = process.env.USER_SERVICE_URL || "http://localhost:8081/api";
        if (!this.baseUrl) {
            throw new Error("No se pudo establecer la conexión con el servicio de usuarios");
        }
    };

    getPersonaByIdentificacion = async (identificacion: string): Promise<PersonaResponse> => {
        const url = `${this.baseUrl}/personas/identificacion/${identificacion}`; //revisar si el endpoint esta creado
        return await FetchClient.get<PersonaResponse>(url);
    };

    getVehiculoByPlaca = async (placa: string): Promise<VehiculoResponse> => {
        const url = `${this.baseUrl}/vehiculos/placa/${placa}`;
        return await FetchClient.get<VehiculoResponse>(url);
    };
}

