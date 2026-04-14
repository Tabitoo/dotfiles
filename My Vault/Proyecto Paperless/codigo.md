useEffect(() => {

        const controller = new AbortController();

  

        const fetchData = async () => {

            const response = await api.call(

                "getCellphonePlans",

                {

                    page: currentPage,

                    limit: entriesPerPage,

                    withoutAssign: showWithoutAssign,

                    param:

                        searchParam == "user" && currentEntity == "plantUser"

                            ? "name"

                            : searchParam,

                    entityName: currentEntity,

                    ...(searchParam == "createdAt"

                        ? searchBetweenDates

                            ? {

                                  dateRange: {

                                      from: searchBetweenDates.from,

                                      to: searchBetweenDates.to,

                                  },

                              }

                            : {

                                  dateSearch:

                                      searchTerm == ""

                                          ? undefined

                                          : new PosixDate(searchTerm as number),

                              }

                        : { search: searchTerm as string }),

                },

                {

                    forceCacheRefresh: true,

                },

            );

  

            if (isError(response)) {

                return;

            }

            setTotalPages(response.totalPages);

            setCellphones(response.cellphonePlans);

        };

  

        fetchData();

  

        return () => controller.abort();

    }, [

        currentPage,

        entriesPerPage,

        searchBetweenDates,

        searchParam,

        searchTerm,

        currentEntity,

        showWithoutAssign,

    ]);