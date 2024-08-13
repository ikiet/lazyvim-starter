local js_print_var_statements = {
  'console.log("-ctkiet-%s %%o", %s)',
}
local js_printf_statements = {
  'console.log("-ctkiet-%s")',
}

return {
  {
    "ThePrimeagen/refactoring.nvim",
    opts = {
      printf_statements = {
        js = js_printf_statements,
        ts = js_printf_statements,
        javascript = js_printf_statements,
        typescript = js_printf_statements,
        javascriptreact = js_printf_statements,
        typescriptreact = js_printf_statements,
      },
      print_var_statements = {
        js = js_print_var_statements,
        ts = js_print_var_statements,
        javascript = js_print_var_statements,
        typescript = js_print_var_statements,
        javascriptreact = js_print_var_statements,
        typescriptreact = js_print_var_statements,
      },
    },
  },
}
