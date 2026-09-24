# CPF / CNPJ
![Build Status](https://github.com/heliohead/cpf_cnpj/actions/workflows/elixir.yml/badge.svg)

This lib does some
[CPF](http://en.wikipedia.org/wiki/Cadastro_de_Pessoas_F%C3%ADsicas)/[CNPJ](http://en.wikipedia.org/wiki/CNPJ)
facilities. It allows you to create, validate, format and generate fake CPF/CNPJ.

It supports the alphanumeric CNPJ format introduced by Receita Federal in July
2026. Numeric and alphanumeric CNPJs coexist and are both accepted. See
[CNPJ Alfanumérico](https://www.gov.br/receitafederal/pt-br/acesso-a-informacao/acoes-e-programas/programas-e-atividades/cnpj-alfanumerico).

## Installation

Add `cpf_cnpj` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cpf_cnpj, "~> 0.2.0"}
  ]
end
```

## Usage

The same API is available for both `Cpf` and `Cnpj`.

```elixir
Cpf.valid?("073.055.920-30")             # => true
Cpf.valid?("073.055.920-30", strict: true)
Cpf.format("07305592030")                # => "073.055.920-30"
Cpf.strip("073.055.920-30")              # => "07305592030"
Cpf.generate()                           # => "41527650030"
Cpf.generate(formatted: true)            # => "415.276.500-30"
Cpf.number_without_verifier("073.055.920-30") # => "073055920"

Cnpj.valid?("12.ABC.345/01DE-35")        # => true (alphanumeric)
Cnpj.valid?("54.550.752/0001-55")        # => true (numeric)
Cnpj.format("12ABC34501DE35")            # => "12.ABC.345/01DE-35"
Cnpj.generate()                          # => "12ABC34501DE35"
```

If you don't know whether a number is a CPF or a CNPJ, use `CpfCnpj.which/1`:

```elixir
CpfCnpj.which("073.055.920-30")    # => Cpf
CpfCnpj.which("12.ABC.345/01DE-35") # => Cnpj
CpfCnpj.which("invalid")            # => nil
```

### Strict validation

By default, only the mask characters `.` `/` `-` are stripped before
validating. Pass `strict: true` to additionally require the input to be in
`XX.XXX.XXX/XXXX-XX` (or bare) form.

Documentation is available at <https://hexdocs.pm/cpf_cnpj>.

## Acknowledgment
It's a port of Nando's [cpf_cnpj](https://github.com/fnando/cpf_cnpj) ruby gem to elixir.

## License
Released under the [MIT License](https://github.com/heliohead/cpf_cnpj/LICENSE).
