#!/usr/bin/env node
const jskos = require("jskos-tools")
const schemes = require("./vocabularies.json")

for (let notation of process.argv.slice(2)) {
  var found = jskos.guessSchemeFromNotation(notation, schemes)
  found = found.map(s=>s.VOC)
  if (found.length) {
    console.log([notation,...found].join("\t"))
  }
}
