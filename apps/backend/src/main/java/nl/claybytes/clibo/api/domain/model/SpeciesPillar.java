package nl.claybytes.clibo.api.domain.model;

public enum SpeciesPillar {
    SOCIAL("S"),
    PHYSICAL("P"),
    EMOTIONAL("E"),
    CAREER("C"),
    INTELLECTUAL("I"),
    ENVIRONMENTAL("E"),
    SPIRITUAL("S");

    private final String code;

    SpeciesPillar(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}
