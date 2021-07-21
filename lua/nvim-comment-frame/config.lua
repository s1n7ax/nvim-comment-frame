local config = {
	start_str = '#',
	end_str = '#',
	fill_char = '-',
	box_width = 80,
	word_wrap_len = 50,

	languages = {

		bash = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		beancount = {
			start_str = ';;',
			end_str = ';;',
			fill_char = '-',
		},
		c = {
			start_str = '--',
			end_str = '--',
			fill_char = '-',
		},
		c_sharp = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		clojure = {
			start_str = ';;',
			end_str = ';;',
			fill_char = '-',
		},
		cmake = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		commonlisp = {
			start_str = ';;',
			end_str = ';;',
			fill_char = '-',
		},
		cpp = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		css = {
			start_str = '/*',
			end_str = '*/',
			fill_char = '-',
		},
		cuda = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		dart = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		devicetree = {
			start_str = '/*',
			end_str = '*/',
			fill_char = '-',
		},
		dockerfile = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		elixir = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		elm = {
			start_str = '--',
			end_str = '--',
			fill_char = '-',
		},
		erlang = {
			start_str = '%',
			end_str = '%',
			fill_char = '-',
		},
		fennel = {
			start_str = ';;',
			end_str = ';;',
			fill_char = '-',
		},
		fish = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		fortran = {
			start_str = '*',
			end_str = '*',
			fill_char = '-',
		},
		gdscript = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		glimmer = {
			start_str = '{{!',
			end_str = '}}',
			fill_char = '-',
		},
		go = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		gomod = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		graphql = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		haskell = {
			start_str = '--',
			end_str = '--',
			fill_char = '-',
		},
		hcl = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		html = {
			start_str = '<!--',
			end_str = '-->',
			fill_char = '-',
		},
		java = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		javascript = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		jsdoc = {
			start_str = '/**',
			end_str = '**/',
			fill_char = '-',
		},
		jsonc = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		julia = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		kotlin = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		latex = {
			start_str = '%',
			end_str = '%',
			fill_char = '-',
		},
		ledger = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		lua = {
			start_str = '--',
			end_str = '--',
			fill_char = '-',
		},
		nix = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		ocaml = {
			start_str = '(**',
			end_str = '**)',
			fill_char = '-',
		},
		ocamllex = {
			start_str = '(**',
			end_str = '**)',
			fill_char = '-',
		},
		php = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		python = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		ql = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		query = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		r = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		rst = {
			start_str = '.. ',
			end_str = ' ..',
			fill_char = '-',
		},
		ruby = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		rust = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		scala = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		scss = {
			start_str = '/*',
			end_str = '*/',
			fill_char = '-',
		},
		sparql = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		supercollider = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		svelte = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		swift = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		teal = {
			start_str = '--',
			end_str = '--',
			fill_char = '-',
		},
		toml = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		typescript = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		turtle = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		verilog = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
		vue = {
			start_str = '<!--',
			end_str = '-->',
			fill_char = '-',
		},
		yaml = {
			start_str = '#',
			end_str = '#',
			fill_char = '-',
		},
		zig = {
			start_str = '//',
			end_str = '//',
			fill_char = '-',
		},
	}
}

return config
