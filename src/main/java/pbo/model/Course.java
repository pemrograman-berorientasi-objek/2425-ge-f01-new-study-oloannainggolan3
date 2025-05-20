package pbo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

//12S23013-Andika Nadadap//
//12S23033-Oloan Nainggolan//
@Entity
@Table(name = "course")
public class Course {

    @Id
    @Column(name = "course_id", nullable = false, length = 255)
    private String kode;

    @Column(name = "course_name", nullable = false, length = 255)
    private String nama;

    @Column(name = "semester", nullable = false, length = 25)
    private int semester;

    @Column(name = "credit", nullable = false, length = 25)
    private int kredit;

    public Course() {
        
    }

    public Course(String kode, String nama, int semester, int kredit) {
        this.kode = kode;
        this.nama = nama;
        this.semester = semester;
        this.kredit = kredit;
    }

    public String getKode() {
        return kode;
    }

    public void setKode(String kode) {
        this.kode = kode;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public int getKredit() {
        return kredit;
    }

    public void setKredit(int kredit) {
        this.kredit = kredit;
    }

    @Override
    public String toString() {
        return kode + "|" + nama + "|" + semester + "|" + kredit;
    }
}
