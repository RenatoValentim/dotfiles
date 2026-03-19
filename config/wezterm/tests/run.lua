local source = debug.getinfo(1, "S").source:sub(2)
local script_dir = source:match("^(.*[/\\])") or ""
local root = script_dir:gsub("tests[/\\]$", "")

package.path = root .. "?.lua;" .. root .. "?/init.lua;" .. package.path

local specs = {
	{ name = "options", module = "tests.options_spec" },
	{ name = "opacity", module = "tests.opacity_spec" },
	{ name = "tabs", module = "tests.tabs_spec" },
	{ name = "keys", module = "tests.keys_spec" },
}

local total = 0
local failures = {}

for _, spec in ipairs(specs) do
	local cases = require(spec.module)

	for _, case in ipairs(cases) do
		total = total + 1

		local ok, err = xpcall(case.run, debug.traceback)
		if ok then
			print("ok - " .. spec.name .. " - " .. case.name)
		else
			local label = spec.name .. " - " .. case.name
			print("not ok - " .. label)
			table.insert(failures, { label = label, err = err })
		end
	end
end

if #failures == 0 then
	print(string.format("%d tests passed", total))
	return
end

print("")
for _, failure in ipairs(failures) do
	print(failure.label)
	print(failure.err)
	print("")
end

os.exit(1)
