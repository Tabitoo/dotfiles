import {

    MockedCryptoService,

    MockedTimeService,

} from "@for-it/domain-lib/mocks";

describe("Create Course", () => {

    const cryptoService = new MockedCryptoService();

    let db: EntityManager;

    const time = new MockedTimeService();

});

  

describe("Add courses", () => {

    const crypto = mockCryptoService();

  

    test("with valid data, add a course", async () => {

        const coursesRepository = mockCoursesService();

  

        await addCourse(

            {

                crypto,

                courses: coursesRepository,

            },

            {

                tags: [],

                status: true,

                category: "servicio",

                details: {

                    descLong: "descripcion larga",

                    descShort: "descripcion corta",

                    subTitle: "subtitulo del curso",

                    title: "titulo del curso",

                },

            },

        );

  

        expect(coursesRepository.courses).toHaveLength(1);

        const newCourse = coursesRepository.courses[0];

        expect(isUUID(newCourse.id)).toBe(true);

        expect(newCourse.details.title).toBe("titulo del curso");

        expect(newCourse.details.descLong).toBe("descripcion larga");

        expect(newCourse.details.descShort).toBe("descripcion corta");

        expect(newCourse.details.subTitle).toBe("subtitulo del curso");

    });

  

    test("with no details provided, fails with invalidDataError", async () => {

        const coursesRepository = mockCoursesService();

  

        const result = await addCourse(

            {

                crypto,

                courses: coursesRepository,

            },

            {

                tags: [],

                status: true,

                category: "servicio",

                details: {

                    descLong: "",

                    descShort: "",

                    subTitle: "",

                    title: "",

                },

            },

        );

  

        expect(result).toBeInstanceOf(InvalidDataError);

    });

});