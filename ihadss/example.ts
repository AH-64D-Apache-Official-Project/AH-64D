
type basefields = {
    fieldA: number
}

type option1 = basefields & {
    type: "option1",
    fieldB: string
}

type option2 = basefields & {
    type: "option2",
    fieldC: string
}

type model = option1 | option2

const example: model = {
    type: "option1",
    fieldA: 1,
    fieldB: "Hi",
}

function useBaseModel(model: model) {
    switch (model.type) {
        case "option1": {
            // Here it is guaranteed I have type option1 in the type system
            // of the compiler
            return
        }
        case "option2": {
            //Here it is guaranteed I have type option2 in the type system
            // of the compiler
            return
        }
    }
}

// What was actually happening

type actbasefields = {
    fieldA: number
}

type actoption1 = {
    fieldB: string,
    base: actbasefields
}

type actoption2 = {
    fieldC: string,
    base: actbasefields
}

type actmodel = {
    base: actbasefields,
    option1: actoption1,
    option2: actoption2
}

// In the example model you were then passing in

const actExample: actmodel = {
    base: {fieldA: 1},
    option1: {fieldB: "Hi", base: {fieldA: 1}},
    option2: {fieldC: "Brad", base: {fieldA: 1}}
}