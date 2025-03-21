import React, { useState, useEffect } from "react";
import { createRoot } from "react-dom/client";
import { defreelance_backend } from "../../declarations/defreelance_backend";

const App = () => {
  const [jobs, setJobs] = useState([]);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");

  useEffect(() => {
    fetchJobs();
  }, []);

  const fetchJobs = async () => {
    const jobList = await defreelance_backend.getJobs();
    setJobs(jobList);
  };

  const createJob = async () => {
    if (!title || !description) return;
    await defreelance_backend.createJob(title, description);
    setTitle("");
    setDescription("");
    fetchJobs();
  };

  return (
    <div style={{ padding: "20px", fontFamily: "Arial" }}>
      <h1>Defreelance - Job Listings</h1>
      <div>
        <input
          type="text"
          placeholder="Job Title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <input
          type="text"
          placeholder="Job Description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
        <button onClick={createJob}>Post Job</button>
      </div>
      <h2>Available Jobs</h2>
      <ul>
        {jobs.map((job, index) => (
          <li key={index}>
            <strong>{job.title}</strong> - {job.description}
          </li>
        ))}
      </ul>
    </div>
  );
};

const root = createRoot(document.getElementById("root"));
root.render(<App />);
