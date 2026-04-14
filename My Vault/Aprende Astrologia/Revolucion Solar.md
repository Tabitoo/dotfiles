
Fecha que devuelve la funcion solcross: 2461176.1156709194


fecha transformada a julian day: 2026-05-15T14:46:33.967Z

2026-05-15T14:46:33.967Z

“Recuerda: la revolución solar comienza el día de tu cumpleaños y dura hasta el siguiente (ej.: 19/12/2025 al 19/12/2026).”

ARGENTINA 
MENDOZA
DEPARTAMENTO CAPITAL
en item ciudad no hay nada FALTA la ciudad MENDOZA fijate


### Codigo version que mas funciona

```ts

/* eslint-disable @typescript-eslint/no-unused-vars */
import { BirthData, RevolutionData, SwephService } from "app-domain";
import sweph, { constants } from "sweph";
import { EPHE_FILES } from "../constants.js";

type RSMode = "calendar" | "covering";

/**
 * Convierte un Julian Day a un objeto Date en UTC.
 */
export function julianToDate(jd: number): Date {
    const J1970 = 2440587.5; // Julian date al epoch Unix (1970-01-01T00:00:00Z)
    const millis = (jd - J1970) * 86400000; // días → milisegundos
    return new Date(millis);
}

/** Devuelve el año de aproximación según el modo elegido */
function targetYearForRS(
    year: number,
    birthMonth: number,
    mode: RSMode,
): number {
    if (mode === "calendar") {
        return year; // revolución dentro del año civil
    }
    // modo covering → si nació en diciembre, el retorno de "year" comienza en dic del año anterior
    return birthMonth === 12 ? year - 1 : year;
}

/**
 * Convierte una fecha en UTC a hora local considerando timezone.
 * @param date Fecha en formato Date (UTC)
 * @param timezone Diferencia horaria en horas respecto a UTC (ej: -3 para Argentina)
 */
export function dateToJulian(
    date: Date,
    timezone: number,
): {
    hour: number;
    minute: number;
    second: number;
    day: number;
} {
    console.log("Fecha que llega al dateToJulian (UTC):", date);

    // 1 hora en milisegundos
    const hourMs = 60 * 60 * 1000;

    // Ajustar la fecha aplicando timezone (ahora sí, restando)
    const adjustedDate = new Date(date.getTime() - timezone * hourMs);

    const day = adjustedDate.getUTCDate();
    const hour = adjustedDate.getUTCHours();
    const minute = adjustedDate.getUTCMinutes();
    const second = adjustedDate.getUTCSeconds();

    return { hour, minute, second, day };
}

export class SwephServiceImplementation implements SwephService {
    calculateSolarReturn(
        birthData: BirthData,
        revolutionData: RevolutionData,
        mode: RSMode = "calendar", // ✅ ahora el modo es parámetro opcional
    ): {
        hour: number;
        minute: number;
        second: number;
        day: number;
    } {
        const ephemerisPath = EPHE_FILES;
        sweph.set_ephe_path(ephemerisPath);

        const {
            date,
            time,
            timezone,
            birthLatitude,
            birthlongitude,
            houseSystem,
        } = birthData;

        const { year, currentLatitude, currentLongitude } = revolutionData;

        console.log("AÑO SOLAR QUE LLEGA DESDE PAYLOAD:", year);
        console.log("VALOR DEL TIMEZONE QUE LLEGA AL SERVICIO:", timezone);

        const [birthYear, birthMonth, birthDay] = date.split("-").map(Number);
        const [hour, minute, second] = time.split(":").map(Number);

        // Función auxiliar para Julian Day corrigiendo timezone
        function toJulianDayUT(
            year: number,
            month: number,
            day: number,
            hour: number,
            minute: number,
            second: number,
            timezone: number,
        ): number {
            const decimalHour = hour + minute / 60 + second / 3600;
            return sweph.julday(
                year,
                month,
                day,
                decimalHour - timezone, // ✅ se corrige a UT
                constants.SE_GREG_CAL,
            );
        }

        const birthJulianDayUT = toJulianDayUT(
            birthYear,
            birthMonth,
            birthDay,
            hour,
            minute,
            second,
            timezone,
        );

        // Posición natal del Sol
        const planetsFlags = constants.SEFLG_SWIEPH;
        const sunPosition = sweph.calc_ut(
            birthJulianDayUT,
            constants.SE_SUN,
            planetsFlags,
        ).data[0];

        // ✅ calcular el año objetivo según el modo
        const targetYear = targetYearForRS(year, birthMonth, mode);

        // Aproximación del retorno solar
        const approxSolarReturnJD = toJulianDayUT(
            targetYear,
            birthMonth,
            birthDay,
            12, // mediodía para asegurar cruce cercano
            0,
            0,
            0, // sin timezone porque ya es UT
        );

        // Buscar cruce exacto
        const result = sweph.solcross_ut(
            sunPosition,
            approxSolarReturnJD,
            planetsFlags,
        );

        if (result.error) {
            throw new Error(result.error);
        }

        const exactSolarReturnJD = result.date;
        const formatedDate = julianToDate(exactSolarReturnJD);

        const formatedJulianDate = dateToJulian(formatedDate, timezone);

        console.log("VALOR DEL RETORNO SOLAR (JD):", exactSolarReturnJD);
        console.log("RETORNO SOLAR EN FECHA UTC:", formatedDate);
        console.log("RETORNO SOLAR AJUSTADO A TIMEZONE:", formatedJulianDate);

        return formatedJulianDate;
    }

    calculateNatalChart(birthData: BirthData): string[] {
        throw new Error("Method not implemented.");
    }
}

```


API KEY GOOGLE MAP
AIzaSyCT3HKwXHuocrh7x6qxvNAO1JU4w57CIuU