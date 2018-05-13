using ArgParse, ApplicationBuilder; using BuildApp

s = ArgParseSettings()

@add_arg_table s begin
    "juliaprog_main"
        arg_type = String
        required = true
        help = "Julia program to compile -- must define julia_main()"
    "appname"
        arg_type = String
        default = nothing
        help = "name to call the generated .app bundle; defaults to basename(juliaprog_main)"
    "builddir"
        arg_type = String
        default = "builddir"
        help = "build directory for output."
    "--verbose", "-v"
        action = :store_true
        help = "increase verbosity"
    "--resource", "-R"
        arg_type = String
        action = :append_arg  # Can specify multiple
        default = nothing
        metavar = "<resource>"
        help = """specify files or directories to be copied to
                  MyApp.app/Contents/Resources/. This should be done for all
                  resources that your app will need to have available at
                  runtime. Can be repeated.

                  NOTE: following the system conventions, -R /path/dir will copy
                  "dir" to Resources/, but -R /path/dir/ will copy all *contents*
                  of `dir/*` to Resources/."""
    "--lib", "-L"
        arg_type = String
        action = :append_arg  # Can specify multiple
        default = nothing
        metavar = "<file>"
        help = """specify user library files to be copied to
                  MyApp.app/Contents/Libraries/. This should be done for all
                  libraries that your app will need to reference at
                  runtime. Can be repeated."""
    "--bundle_identifier"
        arg_type = String
        default = nothing
        metavar = "com.user.appname"
        help = "the bundle identifier for this app. Default: 'com.<USER>.<appname>'."
    "--icns"
        arg_type = String
        default = nothing
        metavar = "<file>"
        help = ".icns file to be used as the app's icon"
    "--app_version"
        arg_type = String
        default = "0.1"
        #range_tester = (x -> r"^[0-9]+(\.[0-9]+)*$"(x))  # can the version have other characters in it? idk..
        metavar = "0.0.1"
        help = ".icns file to be used as the app's icon"
    "--certificate"
        arg_type = String
        default = nothing
        metavar = "<cert_name>"
        help = "name of the certificate to use to sign the app"
    "--entitlements"
        arg_type = String
        default = nothing
        metavar = "<file>"
        help = ".entitlements file. Must set --certificate to add entitlements."
end
s.epilog = """
    examples:\n
    \ua0\ua0 # Build HelloApp.app from hello.jl\n
    \ua0\ua0 build.jl hello.jl HelloApp\n
    \ua0\ua0 # Build MyGame, and copy in imgs/, mus.wav and all files in libs/\n
    \ua0\ua0 build.jl -R imgs -R mus.wav -L lib/* main.jl MyGame
    """

parsed_args = parse_args(ARGS, s)

BuildApp.build_app_bundle(parsed_args)
