package contract

type Message struct {
	Title   string `json:"title"`
	Msg     string `json:"message"`
	AppIcon string `json:"icon"`
	Timeout int    `json:"timeout"`
}

type Signal struct {
	Signal string
	Values string // coma separated values
}
